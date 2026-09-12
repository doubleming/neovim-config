local lsp_group = vim.api.nvim_create_augroup("SetupLSP", {})
local lspconfig_loaded = false
local mason_loaded = false

local mason_commands = {
	{ name = "Mason",             nargs = 0 },
	{ name = "MasonInstall",      nargs = "+" },
	{ name = "MasonUninstall",    nargs = "+" },
	{ name = "MasonUninstallAll", nargs = 0 },
	{ name = "MasonUpdate",       nargs = 0 },
	{ name = "MasonLog",          nargs = 0 },
}

local function ensure_mason_path()
	local mason_root = vim.fs.joinpath(vim.fn.stdpath("data"), "mason")
	local mason_bin = vim.fs.joinpath(mason_root, "bin")
	local path_sep = vim.fn.has("win32") == 1 and ";" or ":"

	vim.env.MASON = mason_root
	if vim.env.PATH and not vim.startswith(vim.env.PATH, mason_bin .. path_sep) and vim.env.PATH ~= mason_bin then
		vim.env.PATH = mason_bin .. path_sep .. vim.env.PATH
	end
end

local function delete_mason_wrappers()
	for _, command in ipairs(mason_commands) do
		pcall(vim.api.nvim_del_user_command, command.name)
	end
end

local function load_mason()
	if mason_loaded then
		return require("mason.api.command")
	end

	require("plugins.snacks").load()
	delete_mason_wrappers()
	vim.pack.add({
		{ src = "https://github.com/mason-org/mason.nvim" },
	})
	ensure_mason_path()
	require("mason").setup()
	mason_loaded = true
	return require("mason.api.command")
end

local function load_lspconfig()
	if lspconfig_loaded then
		return
	end
	lspconfig_loaded = true

	vim.pack.add({
		{ src = "https://github.com/neovim/nvim-lspconfig" },
	})
	ensure_mason_path()

	local lsp_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "config", "lsp")
	for filename in vim.fs.dir(lsp_dir) do
		if filename:match("%.lua$") and filename ~= "init.lua" then
			local mod = "config.lsp." .. filename:gsub("%.lua$", "")
			local ok, err = pcall(require, mod)
			if not ok then
				vim.notify("Failed to load LSP config: " .. mod .. "\n" .. err, vim.log.levels.ERROR)
			end
		end
	end
end

for _, command in ipairs(mason_commands) do
	vim.api.nvim_create_user_command(command.name, function(opts)
		load_mason()
		vim.cmd({ cmd = command.name, args = opts.fargs, bang = opts.bang })
	end, {
		desc = "Lazy-load mason.nvim",
		nargs = command.nargs,
	})
end

ensure_mason_path()
vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
	float = { source = true },
})

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	group = lsp_group,
	once = true,
	callback = load_lspconfig,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_group,
	callback = function(event)
		local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

		-- tH 而非 th：th 已被 snacks 水平终端占用，buffer-local 键会全局键被遮蔽
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			vim.keymap.set("n", "<leader>tH", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, { buffer = event.buf, desc = "LSP: Toggle Inlay Hints" })
		end

		if client and client:supports_method("textDocument/foldingRange") then
			local win = vim.api.nvim_get_current_win()
			vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
		end

		vim.keymap.set("n", "gd", function()
			local src_bufnr = vim.api.nvim_get_current_buf()
			local src_cursor = vim.api.nvim_win_get_cursor(0)
			local params = vim.lsp.util.make_position_params(0, "utf-8")
			vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
				if not result or vim.tbl_isempty(result) then
					vim.notify("No definition found", vim.log.levels.INFO)
					return
				end
				local locations = type(result) == "table" and result[1] and result or { result }
				if #locations == 1 then
					local loc = locations[1]
					local target_uri = loc.uri or loc.targetUri
					local target_range = loc.range or loc.targetSelectionRange or loc.targetRange
					if target_uri and target_range and target_range.start then
						local target_bufnr = vim.uri_to_bufnr(target_uri)
						vim.fn.bufload(target_bufnr)
						if vim.api.nvim_buf_is_valid(src_bufnr) and vim.api.nvim_get_current_buf() ~= src_bufnr then
							vim.cmd("buffer " .. src_bufnr)
						end
						if vim.api.nvim_buf_is_valid(src_bufnr) then
							vim.api.nvim_win_set_cursor(0, src_cursor)
						end
						if target_bufnr ~= src_bufnr then
							vim.cmd("buffer " .. target_bufnr)
							vim.api.nvim_win_set_cursor(0, { target_range.start.line + 1, target_range.start.character })
						else
							vim.cmd(string.format("normal! %dG", target_range.start.line + 1))
						end
						return
					end
				end
				require("plugins.snacks").load().picker.lsp_definitions()
			end)
		end, { buffer = event.buf, desc = "LSP: Goto Definition" })
		vim.keymap.set("n", "gD", function()
			local win = vim.api.nvim_get_current_win()
			local width = vim.api.nvim_win_get_width(win)
			local height = vim.api.nvim_win_get_height(win)

			local value = 8 * width - 20 * height
			if value < 0 then
				vim.cmd("split")
			else
				vim.cmd("vsplit")
			end

			vim.lsp.buf.definition()
		end, { buffer = event.buf, desc = "LSP: Goto Definition (split)" })

		local function jump_to_current_function_start()
			local params = { textDocument = vim.lsp.util.make_text_document_params() }
			local responses = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 1000)
			if not responses then
				return
			end

			local pos = vim.api.nvim_win_get_cursor(0)
			local line = pos[1] - 1

			local function find_symbol(symbols)
				for _, s in ipairs(symbols) do
					local range = s.range or (s.location and s.location.range)
					if range and line >= range.start.line and line <= range["end"].line then
						if s.children then
							local child = find_symbol(s.children)
							if child then
								return child
							end
						end
						return s
					end
				end
			end

			for _, resp in pairs(responses) do
				local sym = find_symbol(resp.result or {})
				if sym and sym.range then
					vim.cmd(string.format("normal! %dG0", sym.range.start.line + 1))
					return
				end
			end
		end

		vim.keymap.set("n", "[f", jump_to_current_function_start, { desc = "Jump to start of current function" })

		local function jump_to_current_function_end()
			local params = { textDocument = vim.lsp.util.make_text_document_params() }
			local responses = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, 1000)
			if not responses then
				return
			end

			local pos = vim.api.nvim_win_get_cursor(0)
			local line = pos[1] - 1

			local function find_symbol(symbols)
				for _, s in ipairs(symbols) do
					local range = s.range or (s.location and s.location.range)
					if range and line >= range.start.line and line <= range["end"].line then
						if s.children then
							local child = find_symbol(s.children)
							if child then
								return child
							end
						end
						return s
					end
				end
			end

			for _, resp in pairs(responses) do
				local sym = find_symbol(resp.result or {})
				if sym and sym.range then
					vim.cmd(string.format("normal! %dG", sym.range["end"].line + 1))
					return
				end
			end
		end

		if
			client
			and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight)
			and vim.bo.filetype ~= "bigfile"
		then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		vim.keymap.set("n", "]f", jump_to_current_function_end, { desc = "Jump to end of current function" })
	end,
})

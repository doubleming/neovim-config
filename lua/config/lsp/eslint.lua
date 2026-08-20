vim.lsp.config("eslint", {
	settings = {
		rulesCustomizations = {
			{ rule = "style/*",   severity = "off", fixable = true },
			{ rule = "format/*",  severity = "off", fixable = true },
			{ rule = "*-indent",  severity = "off", fixable = true },
			{ rule = "*-spacing", severity = "off", fixable = true },
			{ rule = "*-spaces",  severity = "off", fixable = true },
			{ rule = "*-order",   severity = "off", fixable = true },
			{ rule = "*-dangle",  severity = "off", fixable = true },
			{ rule = "*-newline", severity = "off", fixable = true },
			{ rule = "*quotes",   severity = "off", fixable = true },
			{ rule = "*semi",     severity = "off", fixable = true },
			{ rule = "vue/max-attributes-per-line",    fixable = false },
			{ rule = "vue/first-attribute-linebreak",  fixable = false },
			{ rule = "vue/html-self-closing",          fixable = false },
			{ rule = "vue/attributes-order",           fixable = false },
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
		"html",
		"markdown",
		"json",
		"jsonc",
		"yaml",
		"toml",
		"xml",
		"gql",
		"graphql",
		"astro",
		"svelte",
		"css",
		"less",
		"scss",
		"pcss",
		"postcss",
	},
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				local params = vim.lsp.util.make_range_params(0, "utf-16")
				params.context = {
					diagnostics = vim.diagnostic.get(bufnr),
					only = { "source.fixAll" },
				}
				local response = client:request_sync("textDocument/codeAction", params, 2000, bufnr)
				if not response or response.err or not response.result then return end
				for _, action in ipairs(response.result) do
					if action.edit then
						vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
					end
					if action.command then
						vim.api.nvim_buf_execute_command(bufnr, action.command)
					end
				end
			end,
		})
	end,
})

vim.api.nvim_create_user_command("EslintFixAll", function()
	local bufnr = 0
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })
	if not clients or #clients == 0 then
		vim.notify("eslint LSP not attached", vim.log.levels.WARN)
		return
	end
	local client = clients[1]
	local params = vim.lsp.util.make_range_params(bufnr, "utf-16")
	params.context = {
		diagnostics = vim.diagnostic.get(bufnr),
		only = { "source.fixAll" },
	}
	local response = client:request_sync("textDocument/codeAction", params, 2000, bufnr)
	if not response or response.err or not response.result then
		vim.notify("no ESLint fixes available", vim.log.levels.INFO)
		return
	end
	for _, action in ipairs(response.result) do
		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit, "utf-16")
		end
	end
	vim.notify("ESLint fixAll applied", vim.log.levels.INFO)
end, { desc = "ESLint: fix all issues in current buffer" })

vim.lsp.enable("eslint")

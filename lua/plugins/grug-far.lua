vim.pack.add({
	{ src = "https://github.com/MagicDuck/grug-far.nvim" },
})

local function notify_rg_missing()
	vim.notify(
		"[grug-far] ripgrep (`rg`) not found in PATH. Install it, e.g. `brew install ripgrep`.",
		vim.log.levels.WARN,
		{ title = "grug-far" }
	)
end

local default_globs = {
	"*.lua",
	"*.py",
	"*.js",
	"*.ts",
	"*.tsx",
	"*.jsx",
	"*.go",
	"*.rs",
	"*.c",
	"*.cpp",
	"*.h",
	"*.hpp",
	"*.java",
	"*.rb",
	"*.sh",
	"*.md",
	"*.mdx",
	"*.json",
	"*.yaml",
	"*.yml",
	"*.toml",
	"*.html",
	"*.css",
	"*.scss",
	"*.vue",
	"*.svelte",
}

local configured = false

local function setup()
	if configured then
		return require("grug-far")
	end

	configured = true

	if vim.fn.executable("rg") ~= 1 then
		notify_rg_missing()
	end

	require("grug-far").setup({
		engine = "ripgrep",
		default_show_search_results = false,
		default_globs = default_globs,
		default_exclude_globs = nil,
		start_in_insert_mode = true,
		winborders = "rounded",
		winhl = {
			NormalFloat = "Normal",
			FloatBorder = "FloatBorder",
			FloatTitle = "FloatTitle",
			Search = "Search",
			IncSearch = "IncSearch",
			CurSearch = "CurSearch",
		},
		preview = {
			show_diff_previews = true,
		},
		transient = false,
		persist = false,
	})

	return require("grug-far")
end

local function buf_dir()
	local buf = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(buf)
	if name ~= "" then
		local dir = vim.fn.fnamemodify(name, ":p:h")
		if vim.fn.isdirectory(dir) == 1 then
			return dir
		end
	end
	return vim.fn.getcwd()
end

local function open_search_replace(opts)
	if vim.fn.executable("rg") ~= 1 then
		notify_rg_missing()
		return
	end
	setup().open({
		engine = "ripgrep",
		transient = false,
		startInInsertMode = true,
		preview = { showDiffPreviews = true },
		globs = default_globs,
		visualModeUsage = "search",
	}, opts)
end

local function map(key, func, desc)
	vim.keymap.set("n", key, func, { desc = desc })
end

map(
	"<leader>fr",
	function()
		open_search_replace({
			cwd = buf_dir(),
			title = " Search & Replace (cwd) ",
		})
	end,
	"grug-far: search & replace (buffer dir)"
)

map(
	"<leader>fR",
	function()
		local git_root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
		open_search_replace({
			cwd = git_root,
			title = " Search & Replace (git root) ",
		})
	end,
	"grug-far: search & replace (git root)"
)

map(
	"<leader>fW",
	function()
		open_search_replace({
			cwd = buf_dir(),
			title = " Search & Replace (cwd, hidden + ignored) ",
			additional_args = { "--hidden", "--no-ignore" },
		})
	end,
	"grug-far: search & replace (incl. hidden & gitignored)"
)

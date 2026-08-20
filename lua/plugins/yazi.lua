-- Lazy-load yazi.nvim on first buffer interaction. The plugin and its
-- plenary dependency are pulled in via neovim 0.12's `vim.pack.add`.
--
-- `open_for_directories = false` because neo-tree is the primary file
-- manager; we only invoke yazi explicitly via keymap/user command.

local configured = false

local function load_yazi()
	if configured then
		return
	end
	configured = true

	vim.pack.add({
		{ src = "https://github.com/mikavilpas/yazi.nvim" },
		-- plenary is a hard dependency of yazi.nvim; it is also pulled in
		-- by neo-tree, but listing it here makes yazi.nvim self-contained
		-- when neo-tree has not been loaded yet.
		"https://github.com/nvim-lua/plenary.nvim",
	})

	require("yazi").setup({
		open_for_directories = false,
		open_multiple_tabs = false,
		change_neovim_cwd_on_close = false,
		yazi_floating_window_border = "rounded",
		yazi_floating_window_winblend = 0,
		log_level = vim.log.levels.OFF,
	})
end

-- User command: :Yazi [cwd]
vim.api.nvim_create_user_command("Yazi", function(opts)
	load_yazi()
	require("yazi").yazi(opts.args == "cwd" and { cwd = vim.fn.getcwd() } or {})
end, { nargs = "?", desc = "Open yazi (optionally: Yazi cwd)" })

-- Lazy trigger: load on the first BufEnter so that we don't pay the pack
-- cost during early startup.
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("LoadYazi", { clear = true }),
	once = true,
	callback = load_yazi,
})

local configured = false

local function load_supermaven()
	if configured then
		return
	end
	configured = true

	vim.pack.add({
		{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	})

	-- blink.cmp owns <Tab>, so accept supermaven suggestions with <C-l>
	-- instead to avoid the keymap conflict.
	require("supermaven-nvim").setup({
		keymaps = {
			accept_suggestion = "<C-l>",
		},
		log_level = "info",
	})
end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
	group = vim.api.nvim_create_augroup("LoadSupermaven", { clear = true }),
	once = true,
	callback = load_supermaven,
})

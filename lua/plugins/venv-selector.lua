vim.pack.add({
	"https://github.com/linux-cultist/venv-selector.nvim"
})

local configured = false

local function setup_venv_selector()
	if configured then
		return
	end
	configured = true

	require('venv-selector').setup({
		ft = "python",
		opts = {
			options = {},
			search = {},
		},
	})
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("LazyVenvSelector", { clear = true }),
	once = true,
	pattern = "*.py",
	callback = setup_venv_selector,
})

vim.keymap.set("n", "<leader>lv", function()
	setup_venv_selector()
	vim.cmd("VenvSelect")
end, { desc = "VenvSelect" })
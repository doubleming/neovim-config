vim.pack.add({
	"https://github.com/linux-cultist/venv-selector.nvim"
})


require('venv-selector').setup({
  ft = "python", -- Load when opening Python files
  opts = {
    options = {}, -- plugin-wide options
    search = {}   -- custom search definitions
  },
})




vim.keymap.set("n", "<leader>lv", "<cmd>VenvSelect<CR>", { desc = "VenvSelect" })
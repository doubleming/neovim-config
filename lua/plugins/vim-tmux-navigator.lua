if vim.env.TMUX ~= nil and vim.env.TMUX ~= "" then
	vim.g.tmux_navigator_no_mappings = 1
	vim.pack.add({
		"https://github.com/christoomey/vim-tmux-navigator",
	})
	vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Go to left window" })
	vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Go to down window" })
	vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Go to up window" })
	vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Go to right window" })
end

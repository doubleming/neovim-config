-- inc-rename：LSP 重命名时在命令行输入，所有受影响位置实时预览（基于 :command-preview）
vim.pack.add({
	{ src = "https://github.com/smjonas/inc-rename.nvim" },
})

require("inc_rename").setup({})

-- expr 映射把光标下单词预填进命令行，输入过程中即可看到改名效果，回车确认
vim.keymap.set("n", "<leader>lr", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true, desc = "LSP: Rename (live preview)" })

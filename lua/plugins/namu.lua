vim.pack.add({
    { src = "https://github.com/bassamsdata/namu.nvim" }
})

require("namu").setup({})

vim.keymap.set("n", "<leader>ss", ":Namusymbols<cr>", {
        desc = "Jump to LSP symbol",
        silent = true,
})

vim.keymap.set("n", "<leader>sw", ":Namu workspace<cr>", {
    desc = "LSP Symbols - Workspace",
    silent = true,
})

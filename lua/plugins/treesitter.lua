vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup("SetupTreesitter", { clear = true }),
    once = true,
    callback = function()
        vim.pack.add({
            { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
            { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
        })
        require('nvim-treesitter').setup({
            install_dir = vim.fn.stdpath('data') .. '/site'
        })

        require('nvim-treesitter').install { 'rust', 'javascript', 'diff', 'snakemake', 'python', 'toml', 'vue', 'html', 'typescript', 'css' }

        -- mini.comment 需要 treesitter 真正 attach 到 buffer（带 range 的解析），
        -- 才会生成注入的 script/style 子语言树，从而在 Vue 里按区域用对注释符。
        -- nvim-treesitter 的 Highlighting 等特性默认不会自动启用，需显式 start。
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'vue' },
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })

        require("treesitter-context").setup({
            enable = false,
            separator = nil,
            max_lines = 5,
            multiwindow = true,
            min_window_height = 15,
            multiline_threshold = 2,
        })
        vim.api.nvim_set_hl(0, "TreesitterContext", { link = "CursorLine" }) -- remove existing link
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", {
            -- underline = true,
            sp = "#b4befe",
        })
        vim.keymap.set("n", "<leader>tc", "<cmd>TSContext toggle<cr>")
    end,
})

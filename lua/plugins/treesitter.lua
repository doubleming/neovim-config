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

        -- nvim-treesitter 主分支不会自动启用高亮，需按 FileType 显式 start。
        -- 没有 parser 的文件类型（含 ft=bigfile）由 pcall 静默跳过，回落到 legacy syntax；
        -- Vue 里 mini.comment 依赖 TS attach 才能对注入的 script/style 用对注释符，
        -- 这里一并覆盖。
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup("StartTreesitterHighlight", { clear = true }),
            callback = function(ev)
                pcall(vim.treesitter.start, ev.buf)
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

vim.pack.add({
    { src = "https://github.com/folke/flash.nvim" }
})

require("flash").setup({
    prompt = {
        enabled = true,
        prefix = { { "⚡", "FlashPromptIcon" }, { "▏", "FlashPromptPlaceholder" } },
        win_config = {
            relative = "editor",
            border = "rounded",
            width = 12,
            height = 1,
            row = -1,
            col = 0,
            zindex = 1000,
            title = { { " Flash ", "FloatTitle" } },
            title_pos = "left",
        },
    },
    highlight = {
        backdrop = true,
        groups = {
            backdrop = "FlashBackdrop",
            match    = "FlashMatch",
            current  = "FlashCurrent",
            label    = "FlashLabel",
        },
    },
})

vim.api.nvim_set_hl(0, "FlashBackdrop",          { fg = "#7f849c", italic = true })
vim.api.nvim_set_hl(0, "FlashPromptPlaceholder", { fg = "#ff007c", bold  = true })

local keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
}

for _, key in ipairs(keys) do
    vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
end
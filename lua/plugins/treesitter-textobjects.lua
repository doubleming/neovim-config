-- nvim-treesitter-textobjects（main 分支重写版）：基于 treesitter 的参数交换 / 函数间跳转
-- textobjects 查询（queries/<lang>/textobjects.scm）由本插件自带，
-- nvim-treesitter 主分支已不再内置；treesitter 引擎即 Neovim 内置，无插件间依赖
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
})

require("nvim-treesitter-textobjects").setup({
	move = { set_jumps = true }, -- 移动写入 jumplist，可用 <C-o> / <C-i> 跳回
})

local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- ]m / [m 已被内置 method 挪动语义占用，这里统一改成基于 @function.outer 的语义
vim.keymap.set({ "n", "x", "o" }, "]m", function()
	move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })

vim.keymap.set({ "n", "x", "o" }, "[m", function()
	move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Previous function start" })

vim.keymap.set({ "n", "x", "o" }, "]M", function()
	move.goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })

vim.keymap.set({ "n", "x", "o" }, "[M", function()
	move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "Previous function end" })

-- 与相邻参数交换位置（rust / python 等有 @parameter.inner 查询的文件类型可用）
vim.keymap.set("n", "<A-p>", function()
	swap.swap_next("@parameter.inner")
end, { desc = "Swap with next parameter" })

vim.keymap.set("n", "<A-P>", function()
	swap.swap_previous("@parameter.inner")
end, { desc = "Swap with previous parameter" })

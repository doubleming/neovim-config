vim.pack.add({
	{ src = "https://github.com/mg979/vim-visual-multi" },
})

-- VM 在 VM_default_mappings = 0 下只保留部分内置行为，多光标入口需自己接 <Plug>：
--   <C-n>   n: Find-Under（词下开始多光标） / x: Find-Subword-Under（选区开始）
--   <C-q>   n: Start-Regex-Search / x: Visual-Regex（在选区内按正则匹配）
-- 注意：VMStart / VMStartRegex 并不是 VM 提供的 Ex 命令，不能用作映射目标。

vim.g.VM_default_mappings = 0

local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map("n", "<C-n>", "<Plug>(VM-Find-Under)", "Visual-multi: start at word")
map("x", "<C-n>", "<Plug>(VM-Find-Subword-Under)", "Visual-multi: start from selection")
map("n", "<C-q>", "<Plug>(VM-Start-Regex-Search)", "Visual-multi: start regex search")
map("x", "<C-q>", "<Plug>(VM-Visual-Regex)", "Visual-multi: regex search in selection")

return {
	start = function() vim.fn["vm#commands#ctrln"](1) end,
	stop = function() vim.fn["vm#hard_reset"]() end,
}

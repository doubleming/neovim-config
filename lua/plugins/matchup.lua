-- vim-matchup：增强 % 跳转（if/endif、\begin/\end、HTML 标签等）+ i% / a% 文本对象
-- treesitter 引擎直接用 Neovim 内置 treesitter，不依赖 nvim-treesitter 的模块系统
-- 注意：g: 选项必须在插件加载（vim.pack.add）之前设置
-- vimtex 自带 matchit 支持，存在时会禁用 matchup；这里让 matchup 接管 tex 的定界符匹配
vim.g.matchup_override_vimtex = 1
vim.g.matchup_matchparen_offscreen = { method = "popup" }

vim.pack.add({
	{ src = "https://github.com/andymass/vim-matchup" },
})

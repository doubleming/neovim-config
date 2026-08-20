vim.pack.add({
	{ src = "https://github.com/mg979/vim-visual-multi" },
})

-- default keymaps from vim-visual-multi:
--   <C-n>          start at word under cursor (n, x, o)
--   <C-q>          start with regex
--   n / N          next / prev match (operator-pending)
--   [ / ]          add / remove cursor from selection
--   Q              skip cursor
--   <Esc>          exit visual-multi mode
--
-- we only override the start shortcut to avoid surprises with built-ins.

vim.g.VM_default_mappings = 0

local map = function(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

map({ "n", "x" }, "<C-n>", "<cmd>VMStart<CR>", "Visual-multi: start at word")
map({ "n", "x" }, "<C-q>", "<cmd>VMStartRegex<CR>", "Visual-multi: start with regex")

return {
	start = function() vim.cmd("VMStart") end,
	stop = function() vim.cmd("VMStop") end,
}
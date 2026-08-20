vim.o.exrc = true

if vim.loader then
	vim.loader.enable()
end

-- Mason 通过 `python3 -m venv` 创建虚拟环境安装 Python 包。
-- PATH 中的 `python3` 指向 uv 管的 python-build-standalone (cpython-3.13.3)：
-- 它是 standalone 编译，stdlib 通过 executable 的相对路径解析。
-- mason 创建的 venv 会形成 `venv/bin/python3 -> ~/.local/bin/python3 -> uv真实二进制`
-- 的双层 symlink 链，导致 `_NSGetExecutablePath` 解析到中间层后找不到 stdlib，
-- ensurepip 因此失败、venv 创建失败、mason 安装 python-lsp-server 报错。
-- 把 Homebrew 的 python3.12 symlink 成 python3 放进 nvim data 目录，并 prepend 到 PATH。
vim.g.python3_host_prog = "/opt/homebrew/bin/python3.12"

local mason_python_dir = vim.fn.stdpath("data") .. "/mason-python"
if vim.fn.isdirectory(mason_python_dir) == 0 then
	vim.fn.mkdir(mason_python_dir, "p")
end
local py3_shim = mason_python_dir .. "/python3"
if vim.loop.fs_stat(py3_shim) == nil then
	vim.loop.fs_symlink("/opt/homebrew/opt/python@3.12/bin/python3.12", py3_shim)
end
vim.env.PATH = mason_python_dir .. ":" .. (vim.env.PATH or "")

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lsp")
require("config.treesitter_compat").setup()

require("plugins.catppuccin")
require("plugins.vpack")
require("plugins.vim-sleuth")
require("plugins.mini")
require("plugins.comfylnum")
require("plugins.heirline")
require("plugins.completion")
require("plugins.supermaven")
require("plugins.neo-tree")
require("plugins.yazi")
require("plugins.conform")
require("plugins.debugging")
require("plugins.treesitter")
require("plugins.snacks")
require("plugins.vim-tmux-navigator")
require("plugins.switch")
require("plugins.markdown")
require("plugins.typst")
require("plugins.latex")
require("plugins.minuet-ai")
require("plugins.img-clip")
require("plugins.todo-comments")
require("plugins.gitsigns")
require("plugins.opencode")
require("plugins.which-key")
require("plugins.venv-selector")
require("plugins.rustaceanvim")
require("plugins.crates")
require("plugins.noice")
require("plugins.namu")
require("plugins.git-blame")
require("plugins.flash")
require("plugins.grug-far")
require("plugins.harpoon")
require("plugins.visual-multi")
require("plugins.trouble")
require("plugins.aerial")
require("plugins.undotree")

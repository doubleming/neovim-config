# AGENTS.md

个人 Neovim 配置（`~/.config/nvim`），运行在 macOS（Apple Silicon，Homebrew 位于 `/opt/homebrew`），需要 Neovim 0.12+（用到 `vim.pack` 等 API）。注释与提交信息多为中文。

## 目录结构

- `init.lua` — 入口；按固定顺序 `require("config.*")` 与 `require("plugins.*")`。新增插件文件必须在此添加对应的 require
- `lua/config/` — 核心配置：`options` / `keymaps` / `autocmds` / `folding` / `statusline` / `icons` / `treesitter_compat` / `debugging`
- `lua/config/lsp/` — 每个 LSP server 一个文件；`config/lsp/init.lua` 在首次打开 buffer 时自动发现并 require 该目录下除 `init.lua` 外的所有文件，Mason 通过其中的桩 user-commands 懒加载
- `lua/plugins/` — 每个插件一个文件
- `lua/overseer/` — overseer.nvim 任务模板（python、condor 等）
- `after/ftplugin/<ft>.lua` — 按文件类型的设置（tex / markdown / typst / python / json / rust / vue）
- `snippets/*.json` — blink.cmp 代码片段
- `keymap.md` — 全部快捷键的中文速查表
- `nvim-pack-lock.json` — vpack 锁文件（仓库根目录）
- `nvim.log` — 遗留的运行日志，非配置内容，勿编辑

## 插件管理（不使用 lazy.nvim）

- 基于 `vim.pack`，vpack.nvim 提供 UI（`:Vpack` 命令）。增删/更新插件后 `nvim-pack-lock.json` 会变化，需与代码改动一并提交
- 新增插件：新建 `lua/plugins/<name>.lua`，并在 `init.lua` 中按依赖顺序加 `require("plugins.<name>")`
- 懒加载是手动的：插件文件启动时被 require，但真正的 `vim.pack.add` + setup 延迟到 `load()` 函数（模块内 `configured` 标志防重复，见 `snacks.lua` / `conform.lua`）或 autocmd（`completion.lua` 在 InsertEnter 才加载 blink.cmp）
- 跨插件调用必须走公开入口，如 `require("plugins.snacks").load()`，不要在配置加载期直接 `require("snacks")` 等插件模块
- 需要锁版本时用 `version` 字段（如 blink.cmp 的 `'v1.8.0'`）

## 验证方式（无测试、无 lint 配置）

- 校验启动：`nvim --headless +qa`，以无报错退出为准
- 会话内热重载：`<Space>o` 保存并 source 当前文件、`<Space>X` 对当前文件 `:source %`、`<Space>R` 重启 Neovim
- 格式化走 conform.nvim（`<leader>lf`）：lua→stylua，python→ruff，tex→tex-fmt（`~/.cargo/bin`），typst→typstyle，C/C++ 优先 `lcg-clang-format-8.0.0`（LCG 工具链）回落 clang_format

## 关键约定与坑

- Leader 与 localleader 都是 `<Space>`；修改 `lua/config/keymaps.lua` 后须同步更新 `keymap.md`
- `vim.o.exrc = true`：会自动加载项目内的 `.nvim.lua` / `.exrc`，调试异常行为时先想到它
- `init.lua` 顶部的 `pcall(require, "vim.snippet")` 是规避 vim.loader 与 blink.cmp 在 fast event 中找不到模块的已知 bug，勿删
- Python/Mason 的坑（macOS）：PATH 中的 `python3` 是 uv 管理的 python-build-standalone，会让 Mason 建 venv 失败。`init.lua` 将 `vim.g.python3_host_prog` 固定为 Homebrew python3.12，并把 `stdpath("data")/mason-python` shim 目录 prepend 到 PATH，勿删
- 缩进风格不统一（`init.lua` 用 tab，部分插件文件用 4 空格）；vim-sleuth 按 buffer 自适应。编辑时跟随所在文件的既有风格，不要全局重排
- 全局选项：soft wrap 开启、`timeout = false`、`laststatus = 3`、默认 tabstop/shiftwidth=4 + expandtab

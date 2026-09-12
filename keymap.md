# Neovim 快捷键速查

> **Leader = `<Space>`**（`lua/config/options.lua:1`）
>
> 表中 `<leader>` 一律写作 `<Space>`，例如 `<leader>w` 即 `<Space>w`。
> 同一快捷键在不同文件类型下可能有不同含义（如 `<Space>fT`），已在对应小节注明。

---

## 1. 基础 / 通用

| 快捷键 | 作用 |
| --- | --- |
| `<Esc>` | 清除搜索高亮 |
| `<Space>o` | `:update` 后重新 `:source` 当前文件（热重载 lua） |
| `<Space>w` | 保存当前缓冲区 |
| `<Space>Q` | `:wall` 后 `:qa`，保存所有文件并退出 Neovim |
| `<Space>R` | 重启 Neovim |
| `<Space>X` | `:source %`，执行当前 lua 文件 |
| `<Space>x` | 执行当前行（普通模式下）/ 当前选区（可视模式下）的 lua 代码 |
| `\` | 横向分屏 |
| `\|` | 纵向分屏 |
| `<C-s>` | 强制写入当前缓冲区（normal / insert / visual） |
| `L` | 下一个标签页（`gt`） |
| `H` | 上一个标签页（`gT`） |
| `tc` | 关闭当前标签页 |
| `<C-w><C-t>` | 把当前缓冲区在新标签页打开 |
| `j` / `k` | 视觉行移动（无 count 时走 `gj` / `gk`） |

---

## 2. 窗口 / 标签页

| 快捷键 | 作用 |
| --- | --- |
| `<M-Up>` | 当前窗口向上加高 5 行 |
| `<M-Down>` | 当前窗口向下减高 5 行 |
| `<M-Left>` | 当前窗口向左减宽 5 列 |
| `<M-Right>` | 当前窗口向右加宽 5 列 |
| `<C-h>` | 跳到左窗口（tmux 内跨 pane，tmux 外跨 window） |
| `<C-j>` | 跳到下窗口（tmux 内跨 pane，tmux 外跨 window） |
| `<C-k>` | 跳到上窗口（tmux 内跨 pane，tmux 外跨 window） |
| `<C-l>` | 跳到右窗口（tmux 内跨 pane，tmux 外跨 window） |

---

## 3. 终端模式

| 快捷键 | 作用 |
| --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | 终端模式下跳窗口（`<C-\><C-n>` 后接 `<cmd>wincmd …`） |
| `<C-w>s` | 终端模式下横向分屏并开新终端 |
| `<C-w>v` | 终端模式下纵向分屏并开新终端 |

---

## 4. 缓冲区 / 文件树（neo-tree）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>e` | 切换 Neo-tree |
| `<Space>bf` | Neo-tree：聚焦文件系统 |
| `<Space>bb` | Neo-tree：聚焦缓冲区列表 |
| `<Space>bg` | Neo-tree：聚焦 git 状态 |
| `<Space>bc` | 删除当前缓冲区 |
| `<Space>bC` | 删除除当前外的所有缓冲区 |
| `<Space>B` | 显示当前文件 |

---

## 5. 查找 / 搜索（snacks picker + grug-far）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>ff` | 智能查找文件（snacks.picker.smart） |
| `<Space>fo` | 最近打开的文件 |
| `<Space>fw` | ripgrep 全局内容搜索 |
| `<Space>fh` | 帮助文档搜索 |
| `<Space>fl` | 切换 picker 布局 |
| `<Space>fk` | 查找 keymap |
| `<Space><Space>` | 查找缓冲区（按最近使用排序） |
| `<Space>fm` | 查找 mark |
| `<Space>fn` | 历史通知 |
| `<Space>fr` | grug-far：在当前文件目录做搜索 & 替换 |
| `<Space>fR` | grug-far：在 git 根目录做搜索 & 替换 |
| `<Space>fW` | grug-far：包含隐藏 + gitignored 的搜索 & 替换 |
| `<Space>fS` | LSP 工作区符号 |
| `<Space>fs` | 当前缓冲区符号（LSP 不可用时回退到 treesitter） |
| `<Space>fi` | 查找图标（图标选择器） |
| `<Space>fI` | LSP：查找被本函数调用的调用方 |
| `<Space>fO` | LSP：查找本函数调用的所有函数 |
| `<Space>fT` | LSP：跳转到类型定义 |
| `<Space>fP` | 标签页选择器（Tabs picker；含窗口/缓冲区预览，`d` 关闭） |
| `<Space>fb` | 当前缓冲区 grep 行 |
| `<Space>fd` | 当前缓冲区诊断 |
| `<Space>fD` | 所有已加载缓冲区的诊断 |
| `<Space>fH` | 查找高亮组 |
| `<Space>fc` | 查找 nvim 配置目录下的文件 |
| `<Space>f/` | 查找搜索历史 |
| `<Space>fj` | 查找 jump list |
| `<Space>fN` | 查找 `NOTE` 类 TODO |
| `<Space>ft` | 查找 TODO（markdown 下变为查找未勾选 checkbox） |
| `<Space>fF` | 查找行匹配 `FCN=` |
| `grr` | LSP 引用查找（排除声明） |

---

## 6. LSP（随 LspAttach 自动生效）

| 快捷键 | 作用 |
| --- | --- |
| `gd` | LSP 跳转定义；找不到时打开 picker；单结果时直接跳并保留原窗口 |
| `gD` | LSP 跳转定义到分屏（根据窗口宽高自动选 split / vsplit） |
| `[f` | 跳转到当前函数的起始行 |
| `]f` | 跳转到当前函数的结束行 |
| `K` | LSP hover（同时支持时附带 actions） |
| `<Space>tH` | 切换 LSP inlay hints（仅当服务端支持 `textDocument/inlayHint`） |

---

## 7. Treesitter / 上下文

| 快捷键 | 作用 |
| --- | --- |
| `<Space>tc` | 切换 treesitter-context |
| `]m` / `[m` | textobjects：下一个 / 上一个函数开头（rust、python 等有 parser 的语言） |
| `]M` / `[M` | textobjects：下一个 / 上一个函数结尾 |
| `<A-p>` / `<A-P>` | textobjects：当前参数与下一个 / 上一个参数交换位置 |
| `s` | flash：跳转（normal/visual/operator-pending） |
| `S` | flash：treesitter 跳转 |
| `r` | flash：远端跳转（operator-pending） |
| `R` | flash：treesitter 搜索（operator-pending / visual） |
| `<C-s>` | flash：切换搜索（cmdline 模式） |

---

## 8. Git

| 快捷键 | 作用 |
| --- | --- |
| `]c` | 跳到下一个 git hunk（diff 模式下原生跳转） |
| `[c` | 跳到上一个 git hunk |
| `<Space>hs` | stage 当前 hunk（normal 模式）/ 选中行（visual 模式） |
| `<Space>hr` | reset 当前 hunk（normal 模式）/ 选中行（visual 模式） |
| `<Space>hS` | stage 整个缓冲区 |
| `<Space>hR` | reset 整个缓冲区 |
| `<Space>hp` | 预览当前 hunk |
| `<Space>hi` | 内联预览当前 hunk |
| `<Space>hb` | 显示当前行 git blame（full） |
| `<Space>hd` | 关闭 / 打开 diffthis |
| `<Space>hD` | `diffthis ~`（显示未提交的更改） |
| `<Space>hQ` | 把所有 hunk 写入 quickfix |
| `<Space>hq` | 把当前 hunk 写入 quickfix |
| `<Space>tb` | 切换当前行 git blame 虚拟文本 |
| `<Space>tw` | 切换 word diff |
| `ih` | operator/visual 文本对象：选中当前 hunk |
| `<Space>gg` | 打开 lazygit（在 snacks git 根目录） |
| `<Space>gb` | snacks：当前行 git blame |
| `<Space>gu` | snacks：在浏览器打开光标处符号对应的远程仓库页面（带文件与行号） |
| `<Space>tN` | snacks：通知历史 |
| `<Space>n` | snacks：显示通知历史 |
| `<Space>N` | snacks：隐藏通知历史 |

---

## 9. 终端（snacks）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>ts` | 追加终端到终端组（横向分屏，并入底部面板） |
| `<Space>tS` | 追加终端到终端组（纵向分屏，并入底部面板） |
| `<Space>tf` | 打开浮动终端 |
| `<Space>th` | 打开底部水平终端 |
| `<Space>tv` | 打开右侧垂直终端 |
| `<Space>tl` | 切换 lazygit 终端 |
| `<Space>tn` | 切换 node 终端 |
| `<Space>tp` | 切换 python 终端 |
| `<Space>tt` | 切换 btm 终端 |
| `<C-w>s`（terminal） | 追加终端到终端组（横向分屏） |
| `<C-w>v`（terminal） | 追加终端到终端组（纵向分屏） |
| `<F7>` | 打开 / 隐藏 / 恢复整个终端组（normal / terminal 模式） |

> 终端组：F7 管理整个底部终端面板（类似 VS Code）。组内终端通过
> `<Space>ts` / `<Space>tS` / `<C-w>s` / `<C-w>v` 追加；隐藏只关窗口、不杀进程，
> 再次按 F7 原样恢复。原生 `:split | terminal` 仍可通过 Ex 命令手动使用。

> `<Space>tH`（大写）是 LSP inlay hints 开关，见第 6 节；曾用 `<Space>th`，
> 因与水平终端冲突已迁走。

---

## 10. 文件管理 / yazi / mason

| 快捷键 | 作用 |
| --- | --- |
| `<Space>-` | 打开 yazi（当前文件所在目录） |
| `<Space>fy` | 打开 yazi（cwd） |
| `<Space>pm` | Mason 安装器 |
| `<Space>pM` | Mason 更新器 |
| `<Space>lv` | VenvSelect（python 虚拟环境选择） |

---

## 11. Harpoon（标记跳转）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>m` | 切换 Harpoon 快捷菜单 |
| `<Space>ma` | 把当前文件加入 Harpoon |
| `<Space>mr` | 从 Harpoon 移除当前文件 |
| `<Space>mA` | 清空所有 Harpoon 标记 |
| `<Space>mn` | 下一个 Harpoon 文件 |
| `<Space>mp` | 上一个 Harpoon 文件 |
| `<Space>m1` … `<Space>m9` | 直接跳转到第 1–9 个 Harpoon 文件 |

---

## 12. Aerial / 代码大纲

| 快捷键 | 作用 |
| --- | --- |
| `<Space>l` | 切换 Aerial 侧栏 |
| `<Space>L` | 聚焦 Aerial 侧栏 |
| `<Space>ln` | 下一个符号（不移动光标） |
| `<Space>lp` | 上一个符号（不移动光标） |
| `<Space>lN` | 跳到下一个符号（移动光标） |
| `<Space>lP` | 跳到上一个符号（移动光标） |

---

## 13. Trouble（列表窗口）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>Td` | 打开当前缓冲区诊断列表 |
| `<Space>TD` | 切换 workspace diagnostics |
| `<Space>Tl` | 打开 location list |
| `<Space>Tq` | 切换 quickfix 列表 |
| `<Space>Tr` | 切换 LSP references 列表 |
| `<Space>Tc` | 关闭 Trouble |
| `<Space>Tt` | 切换 Trouble |

---

## 14. 调试（DAP）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>du` / `<F1>` | 切换 DAP UI 侧栏 |
| `<Space>ds` / `<F2>` | 启动 / 继续 |
| `<Space>di` / `<F3>` | step into |
| `<Space>do` / `<F4>` | step over |
| `<Space>dO` / `<F5>` | step out |
| `<Space>dq` | 关闭 DAP 会话 |
| `<Space>dr` | 重启当前 frame |
| `<F6>` | DAP 重新开始 |
| `<Space>dQ` / `<F8>` | 终止 DAP 会话 |
| `<Space>dc` | 运行到光标处 |
| `<Space>dR` | 切换 DAP REPL |
| `<Space>dh` | DAP hover |
| `<Space>db` | 切换断点 |
| `<Space>dB` | 设置条件断点（弹窗输入条件） |
| `<Space>dD` | 清除所有断点 |

---

## 15. 编辑辅助

| 快捷键 | 作用 |
| --- | --- |
| `<Space>D` | 复制当前行（yyP） |
| `<A-j>` / `<A-k>` | 普通模式下当前行下移 / 上移 |
| `<A-j>` / `<A-k>` | 可视模式下选区下移 / 上移 |
| `<A-l>` / `<A-h>` | 普通模式下当前行右缩进 / 左反缩进（带 count：`N<A-l>` 缩进 `N` 行） |
| `<A-l>` / `<A-h>` | 可视模式下选区右缩进 / 左反缩进 |
| `<Space>lf` | conform 格式化（normal / visual） |
| `<Space>lr` | LSP 重命名，命令行输入时实时预览所有受影响位置（inc-rename） |
| `<Space>u` | 切换 undotree |
| `<Space>S` | 打开 snacks scratch 草稿缓冲区（同项目复用） |
| `<Space>tz` | 切换 zen 写作模式（居中窄栏，默认联动 dim） |
| `<Space>td` | 切换 snacks dim（弱化光标所在作用域外的内容） |
| `<Space>K` | snacks：悬停显示图片 |
| `<Space>P` | 从系统剪贴板粘贴图片（img-clip） |
| `<Space>oa` | opencode 询问 `@buffer`（normal）或 `@this` 选区（visual） |
| `<Space>ss` | Namu：LSP 当前文件符号 |
| `<Space>sw` | Namu：LSP 工作区符号 |

---

## 16. 跳转 / 诊断 / 列表

| 快捷键 | 作用 |
| --- | --- |
| `[e` | 跳到上一个已加载缓冲区的 ERROR 诊断 |
| `]e` | 跳到下一个已加载缓冲区的 ERROR 诊断 |
| `ge` | 在光标位置弹出诊断浮窗 |
| `<Space>tV` | 切换诊断展示模式：虚拟文本 ↔ 虚拟行（长消息在行下方展开） |
| `[q` | quickfix 上一项 |
| `]q` | quickfix 下一项 |
| `[l` | location list 上一项 |
| `]l` | location list 下一项 |

---

## 17. 可视多光标（visual-multi）

| 快捷键 | 作用 |
| --- | --- |
| `<C-n>` | 从当前词开始可视多光标（normal / visual） |
| `<C-q>` | 用正则启动可视多光标（normal / visual） |
| `<M-u>` | blink.cmp 向上滚动文档 |
| `<M-d>` | blink.cmp 向下滚动文档 |

> 多光标模式下，blink 补全菜单内请用 `<C-n>` / `<C-p>` 切换项、`<C-y>` 接受。
> `<Up>` / `<Down>` / `<CR>` / `<C-u>` / `<C-d>` 被 vim-visual-multi 占用
> （见 `vim-visual-multi/autoload/vm/maps/all.vim`）。

---

## 18. 文件类型：Rust（`after/ftplugin/rust.lua`）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>a` | rustlsp codeAction |
| `K` | rustlsp hover + actions |
| `<Space>a`（带 count） | 按次数触发 hover action |
| `<Space>rr` | 运行当前目标 |
| `<Space>rt` | 列出可运行目标 |
| `<Space>rT` | 列出可测试目标 |
| `<Space>rb` | 重复上次 testable |
| `<Space>rd` | 调试当前目标 |
| `<Space>rD` | 列出可调试目标 |
| `<Space>rp` | 跳到父模块 |
| `<Space>ro` | 打开 Cargo.toml |
| `<Space>rO` | 在 docs.rs 打开当前 crate |
| `<Space>re` | rust-analyzer 解释错误（cycle） |
| `<Space>rE` | rust-analyzer 渲染诊断（cycle） |
| `<Space>rm` | 展开宏 |
| `<Space>rj` | joinLines |
| `<Space>rF` | flyCheck run |
| `<Space>fC` | flyCheck cancel |
| `<Space>rg` | crate graph（dot/svg） |
| `<Space>ti` | 切换 rust-analyzer inlay hints |

---

## 19. 文件类型：Markdown（`after/ftplugin/markdown.lua`）

| 快捷键 | 作用 |
| --- | --- |
| `gx` | 打开光标处 markdown 链接 |
| `zM` | 保存 → `edit!` → 展开 → 折叠到 2 级标题 → 居中光标 |

---

## 20. 文件类型：Typst（`after/ftplugin/typst.lua`）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>tw` | 启动 `typst watch`（避免重复启动）并在 zathura 中打开对应 PDF |

---

## 21. 文件类型：TeX / LaTeX（`after/ftplugin/tex.lua`）

| 快捷键 | 作用 |
| --- | --- |
| `<Space>lb` | 在当前打开的 beamer 缓冲区中搜索 `\begin{frame}` |

---

## 22. 启动面板（snacks dashboard，仅在 dashboard buffer 中）

| 快捷键 | 作用 |
| --- | --- |
| `f` | 智能查找文件 |
| `o` | 查找最近历史 / 最近文件（同一 key 触发两次相同动作） |
| `e` | 新建缓冲区（`:enew`） |
| `L` | Lazy（仅在加载 lazy.nvim 时可用） |
| `P` | Lazy Profile |
| `M` | Mason |
| `q` | 退出 Neovim |

---

## 23. AI 代码补全（minuet virtual-text，`lua/plugins/minuet-ai.lua`）

| 快捷键 | 作用 |
| --- | --- |
| `<A-A>` | 接受整条补全 |
| `<A-a>` | 接受一行 |
| `<A-z>` | 接受 N 行（按提示输入行数） |
| `<A-[>` | 上一条补全（无候选时手动触发） |
| `<A-]>` | 下一条补全（无候选时手动触发） |
| `<A-e>` | 取消当前补全 |

> Insert 模式下输入停顿约 `debounce=600ms` 后自动出现 inline 灰字推荐。
> blink.cmp 弹出菜单时（`show_on_completion_menu = false`，默认）不再画 virtual text，避免视觉重叠。
> 启用 / 关闭当前 buffer 的 auto-trigger：`:Minuet virtualtext toggle`。

---

## 24. 包围编辑（mini.surround，`lua/plugins/mini.lua:90`）

格式：**`sa[motion][id]`** —— motion 必填（`iw` / `aw` / `iW` / `i"` / `ip` …），id 是单字符包围符。

| 快捷键 | 作用 |
| --- | --- |
| `saw{` | 给当前 word 加 `{ var }`（around word，带空格） |
| `saiw{` | 给当前 word 加 `{var}`（inner word，紧贴） |
| `saiW{` | 给当前 WORD 加 `{WORD}`（含 `_-./` 等符号的大词） |
| `sai(` | 给内层加 `(`，例如 `func(a)` → `func((a))`（mini.surround 默认带空格平衡括号） |
| `saip"` | 给段落加 `"` |
| `saib` | 用 `)` 包围（`b` 是 `)` 别名） |
| `saiq` | 用 `"` 包围（`q` 是单/双/反引号别名） |
| `sait` | 给加 HTML/XML 标签，输入 tag 名后回车 |
| `saif` | 给加函数调用，输入函数名后回车 |
| `sa?` | 交互输入左右包围符（如 `sa?<{CR>}<CR>` → `{...}`） |

> **删 / 改 / 查：**
>
> | 快捷键 | 作用 |
> | --- | --- |
> | `sd{` | 删 `{...}` 包围 |
> | `sr{(` | 把 `{...}` 替换成 `(...)` |
> | `sf{` | 跳到当前行下一个 `{`（`sF{` 反向） |
> | `sh{` | 高亮 `{...}` 500ms |
>
> **扩展后缀**（仅删/改/查/高亮生效）：`l` = 上一个，`n` = 下一个。
> 例：`sdl)` 删上一个 `)`；`sdn)` 删下一个 `)`。
>
> **count：** `[count1]sa[count2][motion][id]`，`count1` 重复包围符，`count2` 给 motion。
> 例：`2saiw)` → `((var))`。
>
> **可视模式：** 先 `v` 选中 → `sa{` 直接包围选区（无需 motion）。
>
> **提示：** 按 `sa` 后 **1 秒** 不按 id 会提示 "Reminder to press output surrounding id"，正常连按即可。需关掉加 `silent = true`。

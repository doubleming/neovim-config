vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>Q", ":wall<CR>:qa<CR>", { desc = "Save all and quit" })
vim.keymap.set("n", "<leader>R", ":restart<CR>")
vim.keymap.set(
    { "n", "x", "v" },
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { expr = true, silent = true, desc = "Move cursor down" }
)
vim.keymap.set(
    { "n", "x", "v" },
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { expr = true, silent = true, desc = "Move cursor up" }
)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "\\", "<CMD>:sp<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "|", "<CMD>:vsp<CR>", { desc = "Split window vertically" })
-- lua dev
vim.keymap.set("n", "<space>X", "<cmd>source %<cr>", { desc = "Run this lua file" })
vim.keymap.set("n", "<space>x", ":.lua<cr>", { desc = "Run this line" })
vim.keymap.set("v", "<space>x", ":lua<cr>", { desc = "Run selection" })
-- tab
vim.keymap.set("n", "L", "gt", { noremap = true, desc = "Go to next tab" })
vim.keymap.set("n", "H", "gT", { noremap = true, desc = "Go to prev tab" })
vim.keymap.set("n", "tc", ":tabclose<CR>", { noremap = true, desc = "close the tab" })
vim.keymap.set("n", "<C-w><C-t>", function()
    vim.cmd("tab split")
end, { desc = "Open current buffer in new tab" })
-- neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<leader>bf", ":Neotree focus filesystem<CR>", { desc = "Neo-tree: filesystem" })
vim.keymap.set("n", "<leader>bb", ":Neotree focus buffers<CR>", { desc = "Neo-tree: buffers" })
vim.keymap.set("n", "<leader>bg", ":Neotree focus git_status<CR>", { desc = "Neo-tree: git status" })
-- resize
vim.keymap.set("n", "<M-Up>", "<cmd>resize +5<CR>", { desc = "Resize up" })
vim.keymap.set("n", "<M-Down>", "<cmd>resize -5<CR>", { desc = "Resize down" })
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -5<CR>", { desc = "Resize left" })
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +5<CR>", { desc = "Resize right" })
-- window nav
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Up window" })
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Down window" })
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Left window" })
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Right window" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><cmd>wincmd k<CR>]], { desc = "Up window (from terminal)" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><cmd>wincmd j<CR>]], { desc = "Down window (from terminal)" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><cmd>wincmd h<CR>]], { desc = "Left window (from terminal)" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><cmd>wincmd l<CR>]], { desc = "Right window (from terminal)" })
-- force write
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>write!<CR>", { desc = "Force write" })
-- mason
vim.keymap.set("n", "<leader>pm", "<cmd>Mason<CR>", { desc = "Mason installer" })
vim.keymap.set("n", "<leader>pM", "<cmd>MasonUpdate<CR>", { desc = "Mason updater" })

-- diagnostics: jump to prev/next ERROR across all loaded buffers
local function collect_buffer_diagnostics()
	local items = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			for _, diag in ipairs(vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })) do
				items[#items + 1] = {
					bufnr = bufnr,
					lnum = diag.lnum,
					col = diag.col,
					end_lnum = diag.end_lnum,
					end_col = diag.end_col,
					message = diag.message,
				}
			end
		end
	end
	table.sort(items, function(a, b)
		if a.bufnr == b.bufnr then
			if a.lnum == b.lnum then return a.col < b.col end
			return a.lnum < b.lnum
		end
		return a.bufnr < b.bufnr
	end)
	return items
end

local function jump_to_diagnostic(direction)
	local items = collect_buffer_diagnostics()
	if #items == 0 then
		vim.notify("No errors in loaded buffers", vim.log.levels.INFO)
		return
	end

	local cur_buf = vim.api.nvim_get_current_buf()
	local cur_pos = vim.api.nvim_win_get_cursor(0)
	local cur = { bufnr = cur_buf, lnum = cur_pos[1] - 1, col = cur_pos[2] }

	-- find current position in the sorted list
	local cur_idx
	for i, item in ipairs(items) do
		if item.bufnr == cur.bufnr and item.lnum == cur.lnum and item.col == cur.col then
			cur_idx = i
			break
		end
	end

	if not cur_idx then
		-- not standing on a diagnostic: jump to nearest error in direction
		local target
		if direction == "next" then
			for _, item in ipairs(items) do
				if item.bufnr > cur.bufnr
					or (item.bufnr == cur.bufnr and item.lnum > cur.lnum) then
					target = item
					break
				end
			end
			target = target or items[1]
		else
			for i = #items, 1, -1 do
				local item = items[i]
				if item.bufnr < cur.bufnr
					or (item.bufnr == cur.bufnr and item.lnum < cur.lnum) then
					target = item
					break
				end
			end
			target = target or items[#items]
		end
		vim.cmd("normal! m'") -- save position in jumplist
		vim.api.nvim_set_current_buf(target.bufnr)
		vim.api.nvim_win_set_cursor(0, { target.lnum + 1, target.col })
		return
	end

	local next_idx = direction == "next" and cur_idx + 1 or cur_idx - 1
	if next_idx < 1 or next_idx > #items then
		vim.notify(direction == "next" and "No next error" or "No previous error", vim.log.levels.INFO)
		return
	end

	local target = items[next_idx]
	vim.cmd("normal! m'") -- save position in jumplist
	vim.api.nvim_set_current_buf(target.bufnr)
	vim.api.nvim_win_set_cursor(0, { target.lnum + 1, target.col })
end

vim.keymap.set("n", "[e", function() jump_to_diagnostic("prev") end, { desc = "Previous error in loaded buffers" })
vim.keymap.set("n", "]e", function() jump_to_diagnostic("next") end, { desc = "Next error in loaded buffers" })
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Show diagnostic at cursor" })

-- 诊断展示模式切换：虚拟文本 ↔ 虚拟行（长消息在行下方展开，两者互斥避免重叠）
local diagnostic_line_mode = false
vim.keymap.set("n", "<leader>tV", function()
    diagnostic_line_mode = not diagnostic_line_mode
    vim.diagnostic.config({
        virtual_text = not diagnostic_line_mode,
        virtual_lines = diagnostic_line_mode,
    })
end, { desc = "Toggle virtual lines diagnostics" })

-- yazi
vim.keymap.set("n", "<leader>-", "<cmd>Yazi<CR>", { desc = "Open yazi at current file" })
vim.keymap.set("n", "<leader>fy", "<cmd>Yazi cwd<CR>", { desc = "Open yazi at working directory" })

-- line move (Alt+j/k)
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+1'<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-2'<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

-- line indent (Alt+h/l)
vim.keymap.set("n", "<A-l>", ">>", { desc = "Indent line right" })
vim.keymap.set("n", "<A-h>", "<<", { desc = "Dedent line left" })
vim.keymap.set("v", "<A-l>", ">gv", { desc = "Indent selection right" })
vim.keymap.set("v", "<A-h>", "<gv", { desc = "Dedent selection left" })

-- duplicate
vim.keymap.set("n", "<leader>D", "yyP", { desc = "Duplicate line below" })

-- quickfix / loclist navigation
vim.keymap.set("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>", { desc = "Previous loclist item" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>", { desc = "Next loclist item" })

-- undo tree toggle (set by plugins/undotree.lua)
vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undotree" })

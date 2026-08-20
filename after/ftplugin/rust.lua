local bufnr = vim.api.nvim_get_current_buf()
local function rustlsp(cmd)
	return function()
		vim.cmd.RustLsp(cmd)
	end
end

vim.keymap.set(
	"n",
	"<leader>a",
	rustlsp({ "codeAction" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Code action" }
)
vim.keymap.set(
	"n",
	"K",
	rustlsp({ "hover", "actions" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Hover actions" }
)
vim.keymap.set(
	"n",
	"<space>a",
	"<Plug>RustHoverAction",
	{ buffer = bufnr, desc = "Rust: Invoke hover action by count" }
)

vim.keymap.set(
	"n",
	"<leader>rr",
	rustlsp({ "run" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Run" }
)
vim.keymap.set(
	"n",
	"<leader>rt",
	rustlsp({ "runnables" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Runnables" }
)
vim.keymap.set(
	"n",
	"<leader>rT",
	rustlsp({ "testables" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Testables" }
)
vim.keymap.set(
	"n",
	"<leader>rb",
	rustlsp({ "testables", bang = true }),
	{ silent = true, buffer = bufnr, desc = "Rust: Repeat last testable" }
)
vim.keymap.set(
	"n",
	"<leader>rd",
	rustlsp({ "debug" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Debug" }
)
vim.keymap.set(
	"n",
	"<leader>rD",
	rustlsp({ "debuggables" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Debuggables" }
)

vim.keymap.set(
	"n",
	"<leader>rp",
	rustlsp({ "parentModule" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Parent module" }
)
vim.keymap.set(
	"n",
	"<leader>ro",
	rustlsp({ "openCargo" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Open Cargo.toml" }
)
vim.keymap.set(
	"n",
	"<leader>rO",
	rustlsp({ "openDocs" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Open docs.rs" }
)

vim.keymap.set(
	"n",
	"<leader>re",
	rustlsp({ "explainError", "cycle" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Explain error" }
)
vim.keymap.set(
	"n",
	"<leader>rE",
	rustlsp({ "renderDiagnostic", "cycle" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Render diagnostic" }
)

vim.keymap.set(
	"n",
	"<leader>rm",
	rustlsp({ "expandMacro" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Expand macro" }
)
vim.keymap.set(
	"n",
	"<leader>rj",
	rustlsp({ "joinLines" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Join lines" }
)

vim.keymap.set(
	"n",
	"<leader>rF",
	rustlsp({ "flyCheck", "run" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Fly check" }
)
vim.keymap.set(
	"n",
	"<leader>fC",
	rustlsp({ "flyCheck", "cancel" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Fly check cancel" }
)

vim.keymap.set(
	"n",
	"<leader>rg",
	rustlsp({ "crateGraph", "dot", "svg" }),
	{ silent = true, buffer = bufnr, desc = "Rust: Crate graph" }
)

vim.keymap.set("n", "<leader>ti", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
end, { buffer = bufnr, desc = "Rust: Toggle inlay hints" })

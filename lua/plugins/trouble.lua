local M = {}

local configured = false

local function setup()
	if configured then
		return require("trouble")
	end

	configured = true
	vim.pack.add({
		{ src = "https://github.com/folke/trouble.nvim" },
	})

	local trouble = require("trouble")
	trouble.setup({
		position = "bottom",
		height = 10,
		width = 50,
		icons = {
			ft = "LspKind",
		},
		signs = {
			fold_open = "",
			fold_close = "",
		},
	})

	return trouble
end

M.load = setup

local function map(key, func, desc)
	vim.keymap.set("n", key, func, { desc = desc })
end

local function with_trouble(callback)
	return function(...)
		return callback(setup(), ...)
	end
end

-- diagnostics (current buffer)
map("<leader>Td", with_trouble(function(t)
	t.open("diagnostics")
end), "Trouble: diagnostics")

-- workspace diagnostics (all loaded)
map("<leader>TD", with_trouble(function(t)
	t.toggle("workspace_diagnostics")
end), "Trouble: workspace diagnostics")

-- loclist
map("<leader>Tl", with_trouble(function(t)
	t.open("loclist")
end), "Trouble: loclist")

-- quickfix
map("<leader>Tq", with_trouble(function(t)
	t.toggle("quickfix")
end), "Trouble: quickfix")

-- LSP references
map("<leader>Tr", with_trouble(function(t)
	t.toggle("lsp_references")
end), "Trouble: LSP references")

-- close
map("<leader>Tc", with_trouble(function(t)
	t.close()
end), "Trouble: close")

-- toggle
map("<leader>Tt", with_trouble(function(t)
	t.toggle()
end), "Trouble: toggle")

return M
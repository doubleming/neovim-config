local M = {}

local configured = false

local function setup()
	if configured then
		return require("aerial")
	end

	configured = true
	vim.pack.add({
		{ src = "https://github.com/stevearc/aerial.nvim" },
	})

	require("aerial").setup({
		layout = {
			position = "left",
			width = 30,
			min_width = 10,
			winblend = 0,
		},
		filter_kind = false,
		disable_autofocus = false,
		show_guides = false,
		highlight_on_jump = false,
		keymaps = {
			["{"] = "PrevSibling",
			["}"] = "NextSibling",
		},
	})

	return require("aerial")
end

M.load = setup

local function map(key, func, desc)
	vim.keymap.set("n", key, func, { desc = desc })
end

local function with_aerial(callback)
	return function(...)
		return callback(setup(), ...)
	end
end

-- toggle outline (left side)
map("<leader>l", with_aerial(function(aerial)
	aerial.toggle()
end), "Aerial: toggle outline")

-- focus outline (open + focus)
map("<leader>L", with_aerial(function(aerial)
	aerial.focus()
end), "Aerial: focus outline")

-- next / prev symbol (any side)
map("<leader>ln", with_aerial(function(aerial)
	aerial.next(1, { jump = false })
end), "Aerial: next symbol")

map("<leader>lp", with_aerial(function(aerial)
	aerial.prev(1, { jump = false })
end), "Aerial: prev symbol")

-- jump to next / prev (move cursor)
map("<leader>lN", with_aerial(function(aerial)
	aerial.next(1, { jump = true })
end), "Aerial: jump to next symbol")

map("<leader>lP", with_aerial(function(aerial)
	aerial.prev(1, { jump = true })
end), "Aerial: jump to prev symbol")

return M
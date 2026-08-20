local M = {}

local configured = false

local function setup()
	if configured then
		return require("harpoon")
	end

	configured = true
	vim.pack.add({
		{ src = "https://github.com/lewis6991/harpoon" },
	})

	local harpoon = require("harpoon")
	harpoon.setup({
		settings = {
			save_on_toggle = false,
			sync_on_ui_close = false,
			exitz = false,
		},
	})

	return harpoon
end

M.load = setup

local function map(key, func, desc)
	vim.keymap.set("n", key, func, { desc = desc })
end

local function with_harpoon(callback)
	return function(...)
		return callback(setup(), ...)
	end
end

-- toggle quick menu
map("<leader>m", with_harpoon(function(harpoon)
	harpoon.ui:toggle_quick_menu()
end), "Harpoon: toggle menu")

-- add current file
map("<leader>ma", with_harpoon(function(harpoon)
	harpoon:list():add()
end), "Harpoon: add file")

-- remove current file
map("<leader>mr", with_harpoon(function(harpoon)
	harpoon:list():remove()
end), "Harpoon: remove file")

-- clear all marks
map("<leader>mA", with_harpoon(function(harpoon)
	harpoon:list():clear()
end), "Harpoon: clear all")

-- next / prev file
map("<leader>mn", with_harpoon(function(harpoon)
	harpoon:list():next()
end), "Harpoon: next file")

map("<leader>mp", with_harpoon(function(harpoon)
	harpoon:list():prev()
end), "Harpoon: prev file")

-- direct select 1-9
for i = 1, 9 do
	map("<leader>m" .. i, with_harpoon(function(harpoon)
		harpoon:list():select(i)
	end), "Harpoon: file " .. i)
end

return M
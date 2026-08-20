vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
	"https://github.com/nvim-mini/mini.comment",
	"https://github.com/nvim-mini/mini.pairs",
})

require("mini.icons").setup({
	style = "glyph",
	file = {
		README = { glyph = "󰆈", hl = "MiniIconsYellow" },
		["README.md"] = { glyph = "󰆈", hl = "MiniIconsYellow" },
	},
	filetype = {
		bash = { glyph = "󱆃", hl = "MiniIconsGreen" },
		sh = { glyph = "󱆃", hl = "MiniIconsGrey" },
		toml = { glyph = "󱄽", hl = "MiniIconsOrange" },
	},
})

require("mini.pairs").setup({
	mappings = {
		["("] = { action = "open", pair = "()", neigh_pattern = "[^\\].", register = { cr = false } },
		[")"] = { action = "close", pair = "()", neigh_pattern = "[^\\].", register = { cr = false } },
		["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\].", register = { cr = true } },
		["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\].", register = { cr = false } },
		["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\].", register = { cr = false } },
		["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\].", register = { cr = false } },
		['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
		["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\]", register = { cr = false } },
		["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`]", register = { cr = false } },
	},
})

require("mini.comment").setup({
	-- Options which control module behavior
  options = {
    -- Function to compute custom 'commentstring' (optional)
    custom_commentstring = nil,

    -- Whether to ignore blank lines when commenting
    ignore_blank_line = false,

    -- Whether to ignore blank lines in actions and textobject
    start_of_line = false,

    -- Whether to force single space inner padding for comment parts
    pad_comment_parts = true,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',

    -- Toggle comment on current line
    comment_line = 'gcc',

    -- Toggle comment on visual selection
    comment_visual = 'gc',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    -- Works also in Visual mode if mapping differs from `comment_visual`
    textobject = 'gc',
  },

  -- Hook functions to be executed at certain stage of commenting
  hooks = {
    -- Before successful commenting. Does nothing by default.
    pre = function() end,
    -- After successful commenting. Does nothing by default.
    post = function() end,
  },
})


vim.schedule(function()
	vim.pack.add({
		{ src = "https://github.com/nvim-mini/mini.ai" },
		{ src = "https://github.com/nvim-mini/mini.surround" },
	})

	require("mini.ai").setup({
		mappings = {
			goto_left = "[",
			goto_right = "]",
		},
	})

	require("mini.surround").setup({
		mappings = {
			add = "sa", -- Add surrounding in Normal and Visual modes
			delete = "sd", -- Delete surrounding
			find = "sf", -- Find surrounding (to the right)
			find_left = "sF", -- Find surrounding (to the left)
			highlight = "sh", -- Highlight surrounding
			replace = "sr", -- Replace surrounding
			update_n_lines = "sn", -- Update `n_lines`

			suffix_last = "l", -- Suffix to search with "prev" method
			suffix_next = "n", -- Suffix to search with "next" method
		},
		custom_surroundings = {
			-- HTML 块注释：`sa-` 包裹，`sd-` 删除，`sr-` 替换
			['-'] = {
				input = { '%<!%-%-().-()%-%->' },
				output = { left = '<!--', right = '-->' },
			},
		},
	})
end)

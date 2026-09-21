vim.pack.add({
	{ src = "https://github.com/milanglacier/minuet-ai.nvim" },
})

require("minuet").setup({
	provider = "openai_compatible",
	request_timeout = 2.5,
	throttle = 1500,
	debounce = 600,
	n_completions = 1,
	virtualtext = {
		auto_trigger_ft = { "*" },
		auto_trigger_ignore_ft = {},
		keymap = {
			accept = "<A-A>",
			accept_line = "<A-a>",
			accept_n_lines = "<A-z>",
			next = "<A-]>",
			prev = "<A-[>",
			dismiss = "<A-e>",
		},
		show_on_completion_menu = false,
	},
	provider_options = {
		openai_compatible = {
			api_key = "MINMAX_TOKEN_PLAN_API_KEY",
			end_point = "https://api.minimaxi.com/v1/chat/completions",
			model = "MiniMax-M3",
			name = "MiniMax",
			stream = true,
			optional = {
				max_tokens = 56,
				top_p = 0.9,
				thinking = { type = "disabled" },
			},
		},
	},
})

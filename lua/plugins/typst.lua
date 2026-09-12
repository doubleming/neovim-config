vim.api.nvim_create_user_command("TypstPreview", function(opts)
	vim.pack.add({
		{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	})

	require("typst-preview").setup({
		-- open_cmd = open_cmd,
	})
	-- Re-run the original command
	vim.cmd({
		cmd = "TypstPreview",
		args = opts.fargs,
		bang = opts.bang,
	})
end, {
	nargs = "*",
	bang = true,
	desc = "Lazy-load typst-preview.nvim",
})

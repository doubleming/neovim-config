vim.pack.add({
	{
		src = 'https://github.com/mrcjkb/rustaceanvim',
		version = vim.version.range('^9'),
	},
})

vim.g.rustaceanvim = {
	tools = {},
	server = {
		on_attach = function(client, bufnr) end,
		default_settings = {
				['rust-analyzer'] = {
					checkOnSave = true,
					cargo = {
						allFeatures = false,
					},
					inlayHints = {
					enable = true,
					parameterHints = true,
					typeHints = true,
					chainingHints = true,
				},
				procMacro = { enable = true },
			},
		},
	},
	dap = {
		autoload_configurations = true,
	},
}

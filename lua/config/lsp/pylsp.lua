vim.lsp.config("pylsp", {
	root_markers = { ".git", "pyproject.toml", "setup.py", "setup.cfg", "Pipfile" },
	settings = {
		pylsp = {
			plugins = {
				jedi = {
					extra_paths = { "" },
				},
				rope = {
					ropeFolders = { "" },
				},
			},
		},
	},
	before_init = function(_, config)
		local root = config.root_dir
		if root and root ~= "" then
			table.insert(config.settings.pylsp.plugins.jedi.extra_paths, root)
			table.insert(config.settings.pylsp.plugins.rope.ropeFolders, root)
		end
	end,
})

vim.lsp.enable("pylsp")

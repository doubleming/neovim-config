local mason_root = vim.env.MASON or vim.fn.stdpath("data") .. "/mason"
local vue_plugin_dir = vim.fs.joinpath(
	mason_root,
	"packages",
	"vue-language-server",
	"node_modules",
	"@vue",
	"language-server"
)
local tsserver_path = vim.fs.joinpath(
	mason_root,
	"packages",
	"typescript-language-server",
	"node_modules",
	"typescript",
	"lib",
	"tsserver.js"
)

if vim.fn.isdirectory(vue_plugin_dir) == 1 and vim.fn.filereadable(tsserver_path) == 1 then
	vim.lsp.config("ts_ls", {
		init_options = {
			tsserver = {
				path = tsserver_path,
			},
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = vue_plugin_dir,
					languages = { "vue" },
					configNamespace = "typescript",
				},
			},
		},
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	})
	vim.lsp.enable("ts_ls")
end

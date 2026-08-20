local cargo_bin = vim.fs.joinpath(vim.env.HOME, ".cargo", "bin")
local cargo_texlab = vim.fs.joinpath(cargo_bin, "texlab")

if vim.fn.executable(cargo_texlab) == 1 then
	vim.lsp.config("texlab", {
		cmd = { cargo_texlab },
		cmd_env = {
			PATH = cargo_bin .. ":" .. vim.env.PATH,
		},
	})
	vim.lsp.enable("texlab")
end

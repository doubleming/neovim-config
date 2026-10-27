vim.pack.add({
	{
		src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
		version = vim.version.range('3')
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
})


require('neo-tree').setup({
	sources = {
		"filesystem",
		"buffers",
		"git_status",
	},
	source_selector = {
		winbar = false,
		statusline = false,
		sources = {
			{ source = "filesystem", display_name = "   Files  " },
			{ source = "buffers", display_name = "   Buffers  " },
			{ source = "git_status", display_name = "   Git  " },
		},
	},
	commands = {
		find_files_in_dir = function(state)
			local node = state.tree:get_node()
			local path = node.type == "file" and node:get_parent_id() or node:get_id()
			require("snacks").picker.files { cwd = path }
		end,
		find_all_files_in_dir = function(state)
			local node = state.tree:get_node()
			local path = node.type == "file" and node:get_parent_id() or node:get_id()
			require("snacks").picker.files { cwd = path, hidden = true, ignored = true }
		end,
		find_words_in_dir = function(state)
			local node = state.tree:get_node()
			local path = node.type == "file" and node:get_parent_id() or node:get_id()
			require("snacks").picker.grep { cwd = path }
		end,
		find_all_words_in_dir = function(state)
			local node = state.tree:get_node()
			local path = node.type == "file" and node:get_parent_id() or node:get_id()
			require("snacks").picker.grep { cwd = path, hidden = true, ignored = true }
		end,
	},
	filesystem = {
		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_current",
		window = {
			mappings = {
				["l"] = "toggle_node",
				["h"] = "close_node",
				f = { "show_help", nowait = false, config = { title = "Find Files", prefix_key = "f" } },
				["f/"] = "filter_on_submit",
				ff = "find_files_in_dir",
				fF = "find_all_files_in_dir",
				fw = vim.fn.executable "rg" == 1 and "find_words_in_dir" or nil,
				fW = vim.fn.executable "rg" == 1 and "find_all_words_in_dir" or nil,
				["O"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					-- 如果是文件，先打开其所在目录并选中；如果是目录则直接打开
					if node.type == "file" then
						-- 用系统管理器打开并选中该文件（macOS 用 -R，Linux 用 xdg-open 打开目录）
						local sysname = vim.uv.os_uname().sysname
						if sysname == "Darwin" then
							vim.fn.system({ "open", "-R", path }) -- Finder 中显示并选中
						elseif sysname == "Windows_NT" then
							vim.fn.system({ "explorer.exe", "/select,", path }) -- 资源管理器中选中
						else
							vim.ui.open(vim.fs.dirname(path)) -- xdg-open 打开所在目录
						end
					else
						vim.ui.open(path)
					end
				end,
			},
		},
	},
	buffers = {
		follow_current_file = { enabled = true },
	},
	git_status = {
		window = { position = "float" },
	},
	-- options go here
	default_component_configs = {
		icon = {
			provider = function(icon, node)
				local text, hl
				local mini_icons = require "mini.icons"
				if node.type == "file" then
					text, hl = mini_icons.get("file", node.name)
				elseif node.type == "directory" then
					text, hl = mini_icons.get("directory", node.name)
					if node:is_expanded() then text = nil end
				end

				if text then icon.text = text end
				if hl then icon.highlight = hl end
			end,
		},
		kind_icon = {
			provider = function(icon, node)
				icon.text, icon.highlight = require("mini.icons").get("lsp", node.extra.kind.name)
			end,
		},
	},
})

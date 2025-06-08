return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jvgrootveld/telescope-zoxide",
		"nvim-telescope/telescope-file-browser.nvim", -- File browser added
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local fb_actions = require("telescope").extensions.file_browser.actions

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = "❯ ",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = { mirror = false },
					width = 0.87,
					height = 0.80,
					preview_cutoff = 120,
				},
				sorting_strategy = "ascending",
				file_ignore_patterns = { "node_modules", ".git/" },
				path_display = function(_, path)
					local tail = require("telescope.utils").path_tail(path)
					local dirname = vim.fn.fnamemodify(path, ":h")
					if dirname == "." then
						return tail, { { { 1, #tail }, "Constant" } }
					else
						return string.format("%s (%s)", tail, dirname), { { { 1, #tail }, "Constant" } }
					end
				end,
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<Esc>"] = actions.close,
					},
					n = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<Esc>"] = actions.close,
					},
				},
			},
			extensions = {
				zoxide = {
					prompt_title = "Zoxide",
					mappings = {
						default = {
							action = function(selection)
								vim.cmd.cd(selection.path)
							end,
						},
					},
				},
				file_browser = {
					hijack_netrw = true,
					mappings = {
						i = {
							["<C-c>"] = fb_actions.create,
							["<C-r>"] = fb_actions.rename,
							["<C-x>"] = fb_actions.remove, -- Delete changed to <C-x>
							["<C-y>"] = fb_actions.copy,
							["<C-m>"] = fb_actions.move,
						},
						n = {
							["<C-c>"] = fb_actions.create,
							["<C-r>"] = fb_actions.rename,
							["<C-x>"] = fb_actions.remove, -- Delete changed to <C-x>
							["<C-y>"] = fb_actions.copy,
							["<C-m>"] = fb_actions.move,
						},
					},
				},
			},
		})

		telescope.load_extension("zoxide")
		telescope.load_extension("file_browser")

		local map = vim.keymap.set
		map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		map("n", "<leader>fg", builtin.live_grep, { desc = "Grep Files" })
		map("n", "<leader>fo", builtin.oldfiles, { desc = "Recent Files" })
		map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
		map("n", "<leader>fz", function()
			telescope.extensions.zoxide.list()
		end, { desc = "Zoxide" })
		map("n", "<leader>fe", function()
			telescope.extensions.file_browser.file_browser({
				path = "%:p:h",
				select_buffer = true,
				grouped = true,
				hidden = true,
				respect_gitignore = true,
			})
		end, { desc = "File Browser" })
	end,
}

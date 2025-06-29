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
        hidden = true,
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
        },
        file_browser = {
          hijack_netrw = true,
          mappings = {
            i = {
              ["<C-c>"] = fb_actions.create,
              ["<C-r>"] = fb_actions.rename,
              ["<C-x>"] = fb_actions.remove,
              ["<C-y>"] = fb_actions.copy,
              ["<C-m>"] = fb_actions.move,
            },
            n = {
              ["<C-c>"] = fb_actions.create,
              ["<C-r>"] = fb_actions.rename,
              ["<C-x>"] = fb_actions.remove,
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

    -- Enhanced fz: switch dir, optionally wipe buffers, open alpha
    map("n", "<leader>fz", function()
      require("telescope").extensions.zoxide.list({
        attach_mappings = function(_, map_buf)
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          actions.select_default:replace(function(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            -- Change to selected directory
            vim.cmd.cd(selection.path)

            -- Optional: Wipe all buffers
            -- vim.cmd("bufdo bwipeout")

            -- Open alpha dashboard
            vim.cmd("Alpha")
          end)

          return true
        end,
      })
    end, { desc = "Zoxide + Alpha" })

    map("n", "<leader>fe", function()
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        select_buffer = true,
        grouped = true,
        hidden = true,
      })
    end, { desc = "File Browser" })
  end,
}

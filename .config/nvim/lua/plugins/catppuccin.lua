return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,  -- load immediately at startup
    priority = 1000, -- make sure it loads before other plugins
    config = function()
      require("catppuccin").setup({
          flavour = "mocha", -- or "latte", "frappe", "macchiato"
        transparent_background = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = { enabled = true },
          which_key = true,
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
        },
      })

      -- ✅ Set the colorscheme manually (your preferred way)
      vim.cmd.colorscheme("catppuccin")
      vim.cmd([[
        highlight LineNr guifg=#7f849c
      ]])
    end,
  },
}

local catppuccin = require("catppuccin")

catppuccin.setup({
  compile = {
    enabled = true,
    path = vim.fn.stdpath "cache" .. "/catppuccin",
  },
  transparent_background = true,
  integrations = {
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
    nvimtree = {
      enabled = true,
      show_root = true,
      transparent_panel = true,
    },
  },
})

vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
vim.cmd[[colorscheme catppuccin]]

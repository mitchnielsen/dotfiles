local catppuccin = require("catppuccin")

catppuccin.setup({
  transparent_background = true,
})

vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
vim.cmd[[colorscheme catppuccin]]

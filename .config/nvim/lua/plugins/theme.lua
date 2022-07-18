vim.o.background = "dark" -- or "light" for light mode
local colors = require('gruvbox.palette')

require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  overrides = {
    SignColumn = {bg = colors.dark0},
    StatusLine = {bg = colors.dark0},
    StatusLineNC = {bg = colors.dark0},
    TabLine = {bg = colors.dark0},
  },
})

vim.cmd("colorscheme gruvbox")

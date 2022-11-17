require('nightfox').setup({
  options = {
    transparent = false,    -- Disable setting background
    dim_inactive = false,   -- Non focused panes set to alternative background
    inverse = {             -- Inverse highlight for different types
      match_paren = false,
      visual = false,
      search = false,
    },
  },
})

vim.o.background = "dark" -- light/dark
vim.cmd("colorscheme nordfox")

require'colorizer'.setup() -- show colors over color codes

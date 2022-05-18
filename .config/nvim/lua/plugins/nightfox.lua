require('nightfox').setup({
  options = {
    transparent = true,    -- Disable setting background
    dim_inactive = false,   -- Non focused panes set to alternative background
    styles = {
      comments = "italic",
      types = "italic",
    },
    inverse = {
      visual = true,
      search = true,
    },
  }
})

vim.cmd("colorscheme nordfox")

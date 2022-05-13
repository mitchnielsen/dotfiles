require('nightfox').setup({
  options = {
    transparent = true,    -- Disable setting background
    dim_inactive = false,   -- Non focused panes set to alternative background
    styles = {
      comments = "italic",
      types = "italic",
    },
  }
})

vim.cmd("colorscheme nordfox")

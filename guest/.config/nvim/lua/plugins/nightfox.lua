require('nightfox').setup({
  options = {
    transparent = true,    -- Disable setting background
    dim_inactive = false,   -- Non focused panes set to alternative background
  }
})

vim.cmd("colorscheme nightfox")

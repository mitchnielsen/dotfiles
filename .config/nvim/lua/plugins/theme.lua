return {
  'EdenEast/nightfox.nvim',
  dependencies = {
    'norcalli/nvim-colorizer.lua',
  },
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
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
  end
}

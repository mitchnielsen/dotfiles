return {
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    lazy = false,
    config = function ()
      require('onedark').setup {
          style = 'dark', -- dark, darker, cool, deep, warm, warmer, light
          lualine = {
            transparent = true, -- lualine center bar transparency
          },
      }
      require('onedark').load()
    end
  }
}

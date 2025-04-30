return {
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    lazy = false,
    config = function ()
      require('onedark').setup {
          style = 'cool', -- dark, darker, cool, deep, warm, warmer, light
          lualine = {
            transparent = true, -- lualine center bar transparency
          },
      }
      require('onedark').load()
    end
  },
  {
    'Mofiqul/vscode.nvim',
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function ()
      require('vscode').setup({
        transparent = false,
      })

      vim.cmd.colorscheme "vscode"
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = true,
    config = true,
    priority = 1000, -- make sure to load this before all the other start plugins
  }
}

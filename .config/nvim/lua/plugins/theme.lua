return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "dark", -- dark, darker, cool, deep, warm, warmer, light
        lualine = {
          transparent = true, -- lualine center bar transparency
        },
      })
      require("onedark").load()
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("vscode").setup({
        transparent = false,
        disable_nvimtree_bg = true,
      })

      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup()
      vim.cmd("colorscheme carbonfox")
    end,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      vim.g.nord_italic = false
      vim.g.nord_bold = false

      require("lualine").setup({
        options = {
          theme = "nord",
        },
      })

      vim.cmd.colorscheme("nord")
    end,
  },
  {
    "rmehri01/onenord.nvim",
    lazy = true,
    priority = 1000,
    config = true,
  },
}

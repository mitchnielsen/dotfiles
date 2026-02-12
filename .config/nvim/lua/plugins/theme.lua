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
      vim.cmd("colorscheme nordfox")
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
  {
    "aktersnurra/no-clown-fiesta.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("no-clown-fiesta").setup({
        theme = "dark", -- supported themes are: dark, dim, light
        transparent = false, -- Enable this to disable the bg color
        styles = {
          comments = {},
          functions = {},
          keywords = {},
          lsp = {},
          match_paren = {},
          type = {},
          variables = {},
        },
      })

      vim.cmd.colorscheme("no-clown-fiesta")
    end,
  },
  {
    "oskarnurm/koda.nvim",
    lazy = true, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("koda").setup({
        bold = true, -- disable bold for functions and keywords
        italic = false, -- enable italics for comments and strings
        transparent = false, -- enable for transparent backgrounds
        colors = {
          bg = "#ffffff",
        },
      })

      vim.cmd("colorscheme koda")
      vim.cmd("set background=light")
      vim.cmd("highlight Cursor guibg=#000000 guifg=#000000")
    end,
  },
}

return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "dark", -- dark, darker, cool, deep, warm, warmer, light
        transparent = true,
        lualine = {
          transparent = true, -- lualine center bar transparency
        },
        code_style = {
          comments = "none",
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
    lazy = true,
    priority = 1000,
    config = function()
      require("nightfox").setup()
      vim.cmd("colorscheme dayfox")
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
    lazy = false,
    priority = 1000,
    config = function()
      require("onenord").setup({
        theme = nil, -- "dark" or "light". Alternatively, remove the option and set vim.o.background instead
        borders = true, -- Split window borders
        fade_nc = false, -- Fade non-current windows, making them more distinguishable
        -- Style that is applied to various groups: see `highlight-args` for options
        styles = {
          comments = "italic",
          strings = "NONE",
          keywords = "NONE",
          functions = "NONE",
          variables = "NONE",
          diagnostics = "underline",
        },
        disable = {
          background = true, -- Disable setting the background color
        },
      })
    end,
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

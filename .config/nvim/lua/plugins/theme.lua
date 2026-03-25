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
          transparent = true,
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
    priority = 1000,
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
    lazy = true,
    priority = 1000,
    config = function()
      require("onenord").setup({
        theme = "dark", -- "dark" or "light"
        borders = true,
        fade_nc = false, -- Fade non-current windows, making them more distinguishable
        styles = {
          comments = "italic",
          strings = "NONE",
          keywords = "NONE",
          functions = "NONE",
          variables = "NONE",
          diagnostics = "underline",
        },
        disable = {
          background = true,
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
        theme = "dark", -- dark, dim, light
        transparent = false,
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
    lazy = true,
    priority = 1000,
    config = function()
      require("koda").setup({
        bold = true,
        italic = false,
        transparent = false,
        colors = {
          bg = "#ffffff",
        },
      })

      vim.cmd("colorscheme koda")
      vim.cmd("set background=light")
      vim.cmd("highlight Cursor guibg=#000000 guifg=#000000")
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
        },
      })

      vim.cmd("colorscheme github_light_default")
    end,
  },
}

return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = true,
    config = function()
      require("onedark").setup({
        style = "cool", -- dark, darker, cool, deep, warm, warmer, light
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
      })

      vim.cmd.colorscheme("vscode")
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = true,
    dependencies = "f-person/auto-dark-mode.nvim",
    priority = 1000,
    config = function()
      require("github-theme").setup()
      vim.cmd("colorscheme github_dark_dimmed")
    end,
  },
  {
    "rmehri01/onenord.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("onenord").setup({
        theme = "dark", -- "dark" or "light"

        -- Style that is applied to various groups: see `highlight-args` for options
        styles = {
          comments = "italic",
          diagnostics = "underline",
        },
      })
    end,
  },
  {
    "webhooked/kanso.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("kanso").setup({
        theme = "zen",
        background = {
          dark = "zen",
          light = "pearl",
        },
      })

      vim.cmd("colorscheme kanso")
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
}

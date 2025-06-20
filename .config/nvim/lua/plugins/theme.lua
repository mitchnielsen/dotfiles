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
    lazy = false,
    dependencies = "f-person/auto-dark-mode.nvim",
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
        },
        styles = {
          comments = "italic",
        },
      })

      vim.cmd("colorscheme github_dark_default")

      require("auto-dark-mode").setup({
        update_interval = 3000, -- in milliseconds
        fallback = "dark",
        set_dark_mode = function()
          vim.api.nvim_set_option_value("background", "dark", {})
          vim.cmd("colorscheme github_dark_default")
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value("background", "light", {})
          vim.cmd("colorscheme github_light_default")
        end,
      })
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
}

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
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          transparent = true,
        },
      })

      vim.cmd("colorscheme github_dark_dimmed")
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
    "zenbones-theme/zenbones.nvim",
    lazy = true,
    priority = 1000,
    dependencies = "rktjmp/lush.nvim",
    config = function()
      vim.g.zenbones_darken_comments = 45
      -- vim.cmd.colorscheme("zenwritten")
      -- vim.cmd("set background=light")

      vim.cmd.colorscheme("nordbones")
    end,
  },
  {
    "sam4llis/nvim-tundra",
    lazy = true,
    priority = 1000,
    config = function()
      require("nvim-tundra").setup({})

      vim.g.tundra_biome = "arctic" -- arctic or jungle
      vim.opt.background = "dark"
      vim.cmd.colorscheme("tundra")
    end,
  },
}

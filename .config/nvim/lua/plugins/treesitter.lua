return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "daliusd/incr.nvim", -- incremental selection
  },
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  config = function()
    require("nvim-treesitter").install({
      "bash",
      "dockerfile",
      "go",
      "graphql",
      "hcl",
      "json",
      "lua",
      "make",
      "ruby",
      "terraform",
      "yaml",
    })

    require("incr").setup({
      incr_key = "<tab>",
      decr_key = "<s-tab>",
    })
  end,
}

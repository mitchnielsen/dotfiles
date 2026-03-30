vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/daliusd/incr.nvim",
}, { confirm = false })

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

require("treesitter-context").setup({
  enable = true,
  throttle = true,
  max_lines = 3,
  patterns = {
    default = {
      "class",
      "function",
      "method",
    },
  },
})

require("incr").setup({
  incr_key = "<tab>",
  decr_key = "<s-tab>",
})

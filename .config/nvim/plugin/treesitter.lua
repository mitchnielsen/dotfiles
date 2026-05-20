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

-- nvim-treesitter `main` doesn't auto-start highlighting; do it ourselves.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
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

return {
  "lewis6991/gitsigns.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  lazy = false,
  keys = {
    { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "next git hunk" },
    { "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "previous git hunk" },
    { "<leader>ghp", "<cmd>Gitsigns preview_hunk<CR>", desc = "preview git hunk" },
    { "<leader>ghr", "<cmd>Gitsigns reset_hunk<CR>", desc = "reset git hunk" },
  },
  opts = {
    signcolumn = true,
    linehl = false,
    numhl = false,
    watch_gitdir = {
      interval = 100,
    },
  }
}

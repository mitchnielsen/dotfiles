return {
  "lewis6991/gitsigns.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  lazy = false,
  keys = {
    { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "next git hunk" },
    { "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "previous git hunk" },
  },
  opts = {
    signs = {
      add = { text = "+", numhl = "GitSignsAddNr" },
      change = { text = "~", numhl = "GitSignsChangeNr" },
      delete = { text = "-", numhl = "GitSignsDeleteNr" },
      topdelete = { text = "-", numhl = "GitSignsDeleteNr" },
      changedelete = { text = "~", numhl = "GitSignsChangeNr" },
    },
    watch_gitdir = {
      interval = 100,
    },
    sign_priority = 100, -- take priority over diagnostics
    status_formatter = nil, -- Use default
  }
}

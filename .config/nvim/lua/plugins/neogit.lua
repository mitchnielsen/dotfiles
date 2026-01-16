return {
  "NeogitOrg/neogit",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "ibhagwan/fzf-lua", -- optional
  },
  cmd = "Neogit",
  config = function()
    require("neogit").setup({
      kind = "floating", -- or split_below
      floating = {
        width = 0.8,
        height = 0.8,
      },
      commit_editor = {
        kind = "split_below",
      },
    })
  end,
  keys = {
    { "<leader>GG", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
  },
}

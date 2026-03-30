vim.pack.add({
  "https://github.com/NeogitOrg/neogit",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/sindrets/diffview.nvim",
}, { confirm = false })

require("neogit").setup({
  kind = "floating",
  floating = { width = 0.8, height = 0.8 },
  commit_editor = { kind = "split_below" },
})

vim.keymap.set("n", "<leader>GG", "<cmd>Neogit<cr>", { desc = "Show Neogit UI" })

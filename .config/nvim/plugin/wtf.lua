vim.pack.add({ "https://github.com/piersolenski/wtf.nvim" }, { confirm = false })

require("wtf").setup({
  provider = "anthropic",
})

vim.keymap.set({ "n", "x" }, "<leader>wd", function() require("wtf").diagnose() end, { desc = "Debug diagnostic with AI" })
vim.keymap.set({ "n", "x" }, "<leader>wf", function() require("wtf").fix() end, { desc = "Fix diagnostic with AI" })
vim.keymap.set("n", "<leader>ws", function() require("wtf").search() end, { desc = "Search diagnostic with Google" })
vim.keymap.set("n", "<leader>wp", function() require("wtf").pick_provider() end, { desc = "Pick provider" })
vim.keymap.set("n", "<leader>wh", function() require("wtf").history() end, { desc = "Populate the quickfix list with previous chat history" })
vim.keymap.set("n", "<leader>wg", function() require("wtf").grep_history() end, { desc = "Grep previous chat history with Telescope" })

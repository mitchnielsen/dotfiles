vim.pack.add({
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-rhubarb",
  "https://github.com/shumphrey/fugitive-gitlab.vim",
  "https://github.com/farhanmustar/fugitive-delta.nvim",
  "https://github.com/junegunn/gv.vim",
}, { confirm = false })

vim.keymap.set("n", "<leader>gs", ":Git<cr>", { desc = "git", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>gbr", ":GBrowse<cr>", { desc = "git browse", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>gbR", ":GBrowse!<cr>", { desc = "git browse (copy)", noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>gbl", ":Git blame<cr>", { desc = "git blame", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gd", ":Git diff<cr>", { desc = "git diff", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gps", ":Git push<cr>", { desc = "git push", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gpl", ":Git pull<cr>", { desc = "git pull", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gl", ":GV<cr>", { desc = "git log", noremap = true, silent = true })
vim.keymap.set("n", "<leader>gL", ":GV!<cr>", { desc = "git log for current file", noremap = true, silent = true })

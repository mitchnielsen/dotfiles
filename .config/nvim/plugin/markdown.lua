vim.pack.add({
  "https://github.com/preservim/vim-markdown",
  "https://github.com/brianhuster/live-preview.nvim",
}, { confirm = false })

vim.g.markdown_fenced_languages = { "python", "ruby", "yaml", "go" }
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_no_default_key_mappings = 1
vim.keymap.set("n", "<leader>md", "<cmd>Toch<cr>", { desc = "table of content" })

vim.keymap.set("n", "<leader>mp", function()
  if vim.b.livepreview_running then
    vim.cmd("LivePreview close")
    vim.b.livepreview_running = false
  else
    vim.cmd("LivePreview start")
    vim.b.livepreview_running = true
  end
end, { desc = "Toggle markdown preview" })

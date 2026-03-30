vim.pack.add({
  "https://github.com/brianhuster/live-preview.nvim",
}, { confirm = false })

vim.keymap.set("n", "<leader>md", "gO", { desc = "table of content", remap = true })

vim.keymap.set("n", "<leader>mp", function()
  if vim.b.livepreview_running then
    vim.cmd("LivePreview close")
    vim.b.livepreview_running = false
  else
    vim.cmd("LivePreview start")
    vim.b.livepreview_running = true
  end
end, { desc = "Toggle markdown preview" })

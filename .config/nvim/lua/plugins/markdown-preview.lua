return {
  "brianhuster/live-preview.nvim",
  ft = "markdown",
  keys = {
    {
      "<leader>mp",
      function()
        if vim.b.livepreview_running then
          vim.cmd("LivePreview close")
          vim.b.livepreview_running = false
        else
          vim.cmd("LivePreview start")
          vim.b.livepreview_running = true
        end
      end,
      ft = "markdown",
      desc = "Toggle markdown preview",
    },
  },
}

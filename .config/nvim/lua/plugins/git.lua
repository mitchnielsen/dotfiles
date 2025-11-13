return {
  "tpope/vim-fugitive", -- Git integration
  dependencies = {
    "tpope/vim-rhubarb", -- GitHub support
    "shumphrey/fugitive-gitlab.vim", -- GitLab support
    "farhanmustar/fugitive-delta.nvim", -- Delta in Fugitive
    "junegunn/gv.vim", -- git log browser
  },
  lazy = false,
  keys = {
    { "<leader>gs", ":Git<cr>", desc = "git" },
    { "<leader>gbr", ":GBrowse<cr>", desc = "git browse", mode = { "n", "v" } },
    { "<leader>gbR", ":GBrowse!<cr>", desc = "git browse (copy)", mode = { "n", "v" } },
    { "<leader>gbl", ":Git blame<cr>", desc = "git blame", mode = { "n", "v" } },
    { "<leader>gd", ":Git diff<cr>", desc = "git diff" },
    { "<leader>gps", ":Git push<cr>", desc = "git push" },
    { "<leader>gpl", ":Git pull<cr>", desc = "git pull" },
    { "<leader>gl", ":GV<cr>", desc = "git log" },
    { "<leader>gL", ":GV!<cr>", desc = "git log for current file" },
  },
}

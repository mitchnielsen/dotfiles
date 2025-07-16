return {
  "tpope/vim-fugitive", -- Git integration
  dependencies = {
    "tpope/vim-rhubarb", -- GitHub support
    "shumphrey/fugitive-gitlab.vim", -- GitLab support
  },
  lazy = false,
  keys = {
    { "<leader>gs", ":Git<cr>", "git" },
    { "<leader>gbr", ":GBrowse<cr>", "git browse" },
    { "<leader>gd", ":Gdiff<cr>", "git diff" },
    { "<leader>gps", ":Git push<cr>", "git push" },
    { "<leader>gpl", ":Git pull<cr>", "git pull" },
  },
}

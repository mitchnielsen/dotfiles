return {
  'tpope/vim-fugitive', -- Git integration
  dependencies = {
    'tpope/vim-rhubarb', -- GitHub support
    'shumphrey/fugitive-gitlab.vim', -- GitLab support
  },
  lazy = false,
  keys = {
    {'<leader>gs', ':Git<cr>'},
    {'<leader>gbl', ':Git blame<cr>'},
    {'<leader>gbr', ':GBrowse<cr>'},
    {'<leader>gd', ':Gdiff<cr>'},
    {'<leader>gps', ':Git push<cr>'},
    {'<leader>gpl', ':Git pull<cr>'},
  }
}

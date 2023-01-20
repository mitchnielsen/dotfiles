return {
  'tpope/vim-fugitive', -- Git integration
  dependencies = {
    'shumphrey/fugitive-gitlab.vim',
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

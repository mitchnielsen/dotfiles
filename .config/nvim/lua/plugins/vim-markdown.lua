return {
  'preservim/vim-markdown',
  ft = 'markdown',
  config = function()
    local g = vim.g

    g.markdown_fenced_languages = {'python', 'ruby', 'yaml', 'go'}
    g.vim_markdown_folding_disabled = 1 -- don't automatically fold all sections on open
    g.vim_markdown_no_default_key_mappings = 1 -- don't override mappings like `ge`
  end,
  keys = {
    {"<leader>md", "<cmd>Toch<cr>", desc = "table of content"},
  }
}

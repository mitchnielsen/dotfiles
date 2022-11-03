local g = vim.g

-- Testing with vim-test
g['test#strategy'] = 'vimux'

-- vim-markdown editing
g.markdown_fenced_languages = {'python', 'ruby', 'yaml', 'go'}
g.vim_markdown_folding_disabled = 1 -- don't automatically fold all sections on open
g.vim_markdown_no_default_key_mappings = 1 -- don't override mappings like `ge`

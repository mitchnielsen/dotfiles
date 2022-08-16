local g = vim.g

-- ray-x/go.nvim settings
g.go_fmt_autosave = 1 -- Run gofmt on save
g.go_fmt_command = "goimports" -- Command to run when saving
g.go_auto_type_info = 1 -- Automatically get signature/type info for object under cursor

-- Testing with vim-test
g['test#strategy'] = 'vimux'

-- vim-markdown editing
g.markdown_fenced_languages = {'python', 'ruby', 'yaml', 'go'}
g.vim_markdown_folding_disabled = 1 -- don't automatically fold all sections on open
g.vim_markdown_no_default_key_mappings = 1 -- don't override mappings like `ge`

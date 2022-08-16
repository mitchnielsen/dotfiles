" Leader shortcuts for building, running, testing, etc.
let g:go_fmt_autosave = 1 " Run gofmt on save
let g:go_fmt_command = "goimports" " Command to run when saving
let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor
let g:markdown_fenced_languages = ['python', 'ruby', 'yaml', 'go']
let &fcs='eob: ' " Hide EndOfBuffer

" Testing with vim-test
let test#strategy = "vimux"

" Markdown editing
let g:vim_markdown_folding_disabled = 1 " don't automatically fold all sections on open
let g:vim_markdown_no_default_key_mappings = 1 " don't override mappings like `ge`
set conceallevel=2 " [text](link) shows only text

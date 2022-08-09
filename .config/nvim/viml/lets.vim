" Leader shortcuts for building, running, testing, etc.
let g:go_fmt_autosave = 1 " Run gofmt on save
let g:go_fmt_command = "goimports" " Command to run when saving
let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor
let g:markdown_fenced_languages = ['python', 'ruby', 'yaml']
let &fcs='eob: ' " Hide EndOfBuffer

" Testing with vim-test
let test#strategy = "vimux"

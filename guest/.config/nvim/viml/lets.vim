" Leader shortcuts for building, running, testing, etc.
let g:go_fmt_autosave = 1 " Run gofmt on save
let g:go_fmt_command = "goimports" " Command to run when saving
let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor

" Help vim differentiate <C-i> from <Tab> so jump lists work
let &t_TI = "\<Esc>[>4;2m"
let &t_TE = "\<Esc>[>4;m"

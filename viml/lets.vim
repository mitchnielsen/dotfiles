" quick-scope settings
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Leader shortcuts for building, running, testing, etc.
let g:go_fmt_autosave = 1 " Run gofmt on save
let g:go_fmt_command = "goimports" " Command to run when saving
let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor

" Nerdtree
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeMouseMode = 2
let g:NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
let NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeDirArrowExpandable = "\u00a0" " Disable arrow icons at the left side of folders for NERDTree.
let g:NERDTreeDirArrowCollapsible = "\u00a0" " Disable arrow icons at the left side of folders for NERDTree.
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true

" FZF
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_action = {
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-c': 'split',
  \ 'ctrl-t': 'tabedit' }

" Terraform settings
let g:terraform_align=1
let g:terraform_fold_sections=0
let g:terraform_fmt_on_save=0

" Help vim differentiate <C-i> from <Tab> so jump lists work
let &t_TI = "\<Esc>[>4;2m"
let &t_TE = "\<Esc>[>4;m"

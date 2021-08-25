" Colors
set termguicolors
syntax enable
set background=dark
colorscheme gruvbox
let g:lightline = {
  \ 'colorscheme': 'gruvbox',
  \ 'component_function': {
  \   'filename': 'LightlineFilename',
  \ },
  \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" Match background
" (https://gist.github.com/fuadnafiz98/d91e468c9bc4689868eb0984a29fef66)
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
let &fcs='eob: ' " hide EndOfBuffer '~'
hi Search cterm=NONE ctermfg=grey ctermbg=blue

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

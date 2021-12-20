" Colors
syntax enable
set background=light
colorscheme gruvbox

" Match background
" (https://gist.github.com/fuadnafiz98/d91e468c9bc4689868eb0984a29fef66)
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
let &fcs='eob: ' " hide EndOfBuffer '~'
hi Search cterm=NONE ctermfg=grey ctermbg=blue

" https://github.com/alacritty/alacritty/issues/109#issuecomment-440353106
" https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

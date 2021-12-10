" Filetype autocommands
filetype plugin indent on
autocmd BufNewFile,BufRead *.rb set ft=ruby
autocmd BufNewFile,BufRead Dockerfile* set syntax=Dockerfile
autocmd BufNewFile,BufRead *.tpl set syntax=go
autocmd BufNewFile,BufRead *.j2 set syntax=jinja
autocmd InsertEnter,InsertLeave * set cul!

" Building, running, testing, etc.
autocmd FileType ruby map <leader>r :w<CR>:exec '!ruby' shellescape(@%, 1)<CR>
autocmd FileType python map <leader>r :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>r :w<CR>:exec '!go run' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>t :w<CR>:exec '!go test'<CR>
autocmd FileType sh map <leader>r :w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red ctermfg=white guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Spacing
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType make setlocal noexpandtab

" augroup MyColorsAugroupColorschemeCleanup
"   autocmd!
"   autocmd ColorScheme,Syntax,FileType * highlight Normal ctermbg=NONE guibg=NONE gui=NONE
" augroup END

" Tweak the :Rg command
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --glob "!.git/*" --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

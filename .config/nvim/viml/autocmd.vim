" Filetype autocommands
filetype plugin indent on
autocmd BufNewFile,BufRead Dockerfile* set syntax=Dockerfile
autocmd BufNewFile,BufRead Dangerfile set syntax=ruby
autocmd BufNewFile,BufRead *.tpl set syntax=yaml
autocmd BufNewFile,BufRead *.yaml set syntax=yaml
autocmd BufNewFile,BufRead *.yml set syntax=yaml

" Set spelling and textwidth for git commits
autocmd Filetype gitcommit setlocal spell textwidth=72

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
autocmd FileType make setlocal noexpandtab

" Go to the beginning of the line in insert mode
inoremap <silent><C-a> <C-o>0
" Go to the ending of the line in insert mode
inoremap <silent><C-b> <C-o>$
" Yank from the system clipboard(in normal mode)
" nnoremap <silent><leader>y "*y
nnoremap <silent><leader>y :OSCYank<CR>
" Yank from the system clipboard(in visual mode)
" vnoremap <silent><leader>y "*y
vnoremap <silent><leader>y :OSCYank<CR>
" Cut from the system clipboard(in normal mode)
nnoremap <silent><leader>x "*x
" Cut from the system clipboard(in visual mode)
vnoremap <silent><leader>x "*x
" Paste from the system clipboard(in normal mode)
nnoremap <silent><leader>p "*p
" Paste from the system clipboard(in visual mode)
nnoremap <silent><leader>p "*p

" " Yank to system clipboard
" nmap <leader>o <Plug>OSCYank

" Toggle search highlight
nnoremap <silent> <C-C> :if (&hlsearch == 1) \| set nohlsearch \| else \| set hlsearch \| endif<cr>
" Do not make Q go to ex-mode
nnoremap Q <Nop>

" Wrap selection with ''
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
" Wrap selection with ""
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
" Wrap selection with ()
vnoremap <leader>( <esc>`>a)<esc>`<i(<esc>
" Wrap selection with []
vnoremap <leader>[ <esc>`>a]<esc>`<i[<esc>
" Wrap selection with {}
vnoremap <leader>{ <esc>`>a}<esc>`<i{<esc>

inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Lspsaga
" Show hovering documentation
nnoremap <silent>K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" Rename symbols
nnoremap <silent>gR <cmd>lua require('lspsaga.rename').rename()<CR>

" LSP
" References
nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<CR>
" Implementation
nnoremap <silent>gi <cmd>lua vim.lsp.buf.implementation()<CR>
" definition
nnoremap <silent> gD <cmd>lua vim.lsp.buf.definition()<CR>

" Show full error
nnoremap <silent>ge <cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>

" Jump between errors
nnoremap <silent>]e <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent>[e <cmd>lua vim.diagnostic.goto_prev()<CR>

" Toggle error menu
nnoremap <silent><leader>h :TroubleToggle<CR>

" Show symbols outline
nnoremap <silent><leader>so :SymbolsOutline<CR>

" Searching
nnoremap <leader>rg :FzfLua live_grep_glob<CR>
nnoremap <leader>rG :FzfLua live_grep_resume<CR>
nnoremap <leader>rw :FzfLua grep_cword<CR>
nmap <Leader>f :FzfLua files<CR>
nmap <Leader>b :FzfLua buffers<CR>

" Quick close
nnoremap <leader><leader> :x<cr>

" Yank to end
nnoremap Y y$

" Keep things centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Better break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Better text movement
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Fugitive mappings
nmap <leader>gs :Git<cr>
nmap <leader>gbl :Git blame<cr>
nmap <leader>gbr :Gbrowse<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gps :Git push<cr>
nmap <leader>gpl :Git pull<cr>

" Lazygit mappings
nnoremap <silent> <leader>gg :LazyGit<CR>

" Nvim-Tree
nnoremap <leader>n :NvimTreeFindFileToggle<CR>

command LoadPacker lua require 'pluginList'

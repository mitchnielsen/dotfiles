" Go to the beginning of the line in insert mode
inoremap <silent><C-a> <C-o>0
" Go to the ending of the line in insert mode
inoremap <silent><C-b> <C-o>$
" Paste from the system clipboard(in normal mode)
nnoremap <silent><leader>y "*y
" Paste from the system clipboard(in visual mode)
vnoremap <silent><leader>y "*y
" Cut from the system clipboard(in normal mode)
nnoremap <silent><leader>x "*x
" Cut from the system clipboard(in visual mode)
vnoremap <silent><leader>x "*x
" Paste from the system clipboard(in normal mode)
nnoremap <silent><leader>p "*p
" Paste from the system clipboard(in visual mode)
nnoremap <silent><leader>p "*p
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

" compe completion
" Use enter to select
inoremap <silent><expr> <CR> compe#confirm('<CR>')
" Close compe-completion popup
inoremap <silent><expr> <C-e> compe#close('<C-e>')
" Scroll down compe auto-docs
inoremap <silent><expr> <C-f> compe#scroll({ 'delta': +4 })
" Scroll up compe auto-docs
inoremap <silent><expr> <C-d> compe#scroll({ 'delta': -4 })

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

" Toggle error menu
nnoremap <silent><leader>h :TroubleToggle<CR>

" Show symbols outline
nnoremap <silent><leader>so :SymbolsOutline<CR>

" Searching
nnoremap <leader>rg :FzfLua live_grep_native<CR>
nnoremap <leader>rG :FzfLua live_grep_resume<CR>
nnoremap <leader>rw :FzfLua grep_cword<CR>
nmap <Leader>f :FzfLua files<CR>
nmap <Leader>b :FzfLua buffers<CR>

" Quick close
nnoremap <leader><leader> :x<cr>

" More natural line jumps on wrapped lines
nnoremap j gj
nnoremap k gk

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

" NERDTree
nnoremap <expr> <leader>n g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'
nmap <leader>N :NERDTreeFind<CR>

command LoadPacker lua require 'pluginList'

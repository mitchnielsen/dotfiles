" Plug installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug plugins
call plug#begin('~/.vim/bundle')

" Language support
Plug 'neovim/nvim-lspconfig' " LSP support on nvim nightly
Plug 'nvim-lua/completion-nvim' " Completion to go with LSP
Plug 'sheerun/vim-polyglot' " syntax highlighting for many languages
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': 'go' }

" Git integration
Plug 'tpope/vim-fugitive' " Git integration
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'airblade/vim-gitgutter'

" Conveniences
Plug 'machakann/vim-highlightedyank' " Highlight yanked line
Plug 'unblevable/quick-scope' " Quick jump in line
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree view
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " Git in tree view
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' } " Icons for NerdTree
Plug 'junegunn/fzf' " Fuzzy finder binary
Plug 'junegunn/fzf.vim' "Fuzzy finder vim plugin
Plug 'wakatime/vim-wakatime' " Send data to Wakatime
Plug 'tpope/vim-unimpaired' " Simple mappings
Plug 'preservim/nerdcommenter' " Commenting made easier
Plug 'takac/vim-commandcaps' " takes care of caps typos
Plug 'ChartaDev/charta.vim' " learn new codebases and share explanations
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'phaazon/hop.nvim'

" Themes
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'

call plug#end()

" Set leader to space
let mapleader = " "

" Settings
set number
set relativenumber
set noshowmode " for lightline to hide repetitive mode
set t_Co=256
if has('termguicolors')
  set termguicolors " so background matches color scheme
endif
set encoding=UTF-8
set fileformat=unix
set autoread " reload files changed outside of vim
set ruler
set laststatus=2
set nopaste
set noerrorbells
set mouse=a
set hidden
set noswapfile
set backspace=indent,eol,start
set scrolloff=5
set clipboard=unnamed " yank to system clipboard
set showcmd
set showmatch
set ignorecase
set smartcase
set hlsearch
set incsearch
set wildmenu " Autocomplete filenames
set wildignore=*.o,*.hi,*.pyc
set updatetime=100 " Git gutter
set splitbelow
set splitright
set nocompatible
set diffopt=vertical
set cursorline

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
nmap <leader>gs :Gstatus<cr>
nmap <leader>gbl :Gblame<cr>
nmap <leader>gbr :Gbrowse<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gps :Git push<cr>
nmap <leader>gpl :Git pull<cr>
nmap <leader>gplm :Git pull origin master<cr>

" Colors
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

" quick-scope settings
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Filetype settings
filetype plugin indent on
autocmd BufNewFile,BufRead *.rb set ft=ruby
autocmd BufNewFile,BufRead Dockerfile* set syntax=Dockerfile
autocmd BufNewFile,BufRead *.j2 set syntax=jinja
autocmd InsertEnter,InsertLeave * set cul!
autocmd Filetype python,go setl omnifunc=v:lua.vim.lsp.omnifunc

" Leader shortcuts for building, running, testing, etc.
autocmd FileType ruby map <leader>r :w<CR>:exec '!ruby' shellescape(@%, 1)<CR>
autocmd FileType python map <leader>r :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>r :w<CR>:exec '!go run' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>t :w<CR>:exec '!go test'<CR>
autocmd FileType sh map <leader>r :w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>
let g:go_fmt_autosave = 1 " Run gofmt on save
let g:go_fmt_command = "goimports" " Command to run when saving
let g:go_auto_type_info = 1 " Automatically get signature/type info for object under cursor

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red ctermfg=white guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Nerdtree
let g:NERDTreeShowIgnoredStatus = 1
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
nmap <leader>nt :NERDTree<cr>

" Fuzzy finder
set rtp+=/usr/local/bin/fzf
nmap <Leader>f :Files<CR>
nmap <Leader>b :Buf<CR>

" FZF
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_action = {
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-c': 'split',
  \ 'ctrl-t': 'tabedit' }

" Little hack to fix the split/scroll problem
tabnew
bwipeout

" Terraform settings
let g:terraform_align=1
let g:terraform_fold_sections=0
let g:terraform_fmt_on_save=0

" Spacing settings
set shiftwidth=2
set tabstop=2
set expandtab
set softtabstop=2
set smartindent
set autoindent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType make setlocal noexpandtab

" echodoc
let g:echodoc#type = "echo"
set cmdheight=2
let g:echodoc_enable_at_startup = 1

" Completion
set omnifunc=v:lua.vim.lsp.omnifunc
set completeopt=menuone,noinsert,noselect
set shortmess+=c " Avoid showing message extra message when using completion
let g:completion_enable_auto_popup = 1
let g:completion_trigger_on_delete = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_auto_change_source = 1
let g:completion_enable_auto_hover = 1
"let g:completion_chain_complete_list = [{'complete_items': ['omni']}]
"let g:completion_chain_complete_list = [
    "\{'mode': 'lsp'},
"\]
" Auto suggestions on '.'
" au filetype go inoremap <buffer> . .<C-x><C-o>
imap <tab><tab> <c-x><c-o>

" LSP
autocmd BufEnter * lua require'completion'.on_attach()
lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}
lua require'lspconfig'.solargraph.setup{on_attach=require'completion'.on_attach}
" Bindings
nnoremap <silent>gd <C-w><C-v> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent>K  <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent>rn <cmd>lua vim.lsp.buf.rename()<CR>

" Help vim differentiate <C-i> from <Tab> so jump lists work
let &t_TI = "\<Esc>[>4;2m"
let &t_TE = "\<Esc>[>4;m"

" Searching
nnoremap <leader>rg :Rg <C-r><C-w><CR>

" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
 ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,
  },
}
EOF

" phaazon/hop.nvim
nmap <Leader>/ :HopWord<CR>

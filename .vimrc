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
Plug 'psliwka/vim-smoothie' " smooth scrolling
Plug 'editorconfig/editorconfig-vim'
Plug 'Yggdroot/indentLine' " Show indentation markers
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree view
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' } " Git in tree view
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' } " Icons for NerdTree
Plug 'junegunn/fzf' " Fuzzy finder binary
Plug 'junegunn/fzf.vim' "Fuzzy finder vim plugin
Plug 'wakatime/vim-wakatime' " Send data to Wakatime
Plug 'ervandew/supertab' " Tab for autocomplete
Plug 'tpope/vim-unimpaired' " Simple mappings
Plug 'preservim/nerdcommenter' " Commenting made easier
Plug 'Shougo/echodoc.vim' " show function signatures
Plug 'voldikss/vim-floaterm' " floating terminal

" Themes
Plug 'itchyny/lightline.vim'
Plug 'rakr/vim-one'

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

" Fugitive mappings
nmap <leader>gs :Gstatus<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gps :Git push<cr>
nmap <leader>gpl :Git pull<cr>
nmap <leader>gplm :Git pull origin master<cr>

" Golang - show omnicomplete on '.'
let g:SuperTabCrMapping = 1

" IndentLine settings
let g:indentLine_setConceal = 0

" Clear search highlights
nmap <silent> <leader>/ :nohlsearch<CR>

" Colors
syntax enable
set background=dark
colorscheme one
let g:lightline = {'colorscheme': 'one'}

" Match background
hi Normal ctermbg=NONE guibg=NONE
hi NonText ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE
hi clear SignColumn
hi clear LineNR

" quick-scope settings
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" Filetype settings
filetype plugin indent on
autocmd BufNewFile,BufRead *.rb set ft=ruby
autocmd BufNewFile,BufRead Dockerfile* set syntax=Dockerfile
autocmd BufNewFile,BufRead *.j2 set syntax=jinja
autocmd FileType vim let b:vcm_tab_complete = 'vim'
autocmd InsertEnter,InsertLeave * set cul!

" Leader shortcuts for building, running, testing, etc.
autocmd FileType ruby map <leader>r :w<CR>:exec '!ruby' shellescape(@%, 1)<CR>
autocmd FileType python map <leader>r :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>r :w<CR>:exec '!go run' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>b :w<CR>:exec '!go build' shellescape(@%, 1)<CR>
autocmd FileType go map <leader>t :w<CR>:exec '!go test'<CR>
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

" Switching tabs
nmap <S-Tab> :tabprev<cr>
nmap<Tab> :tabnext<cr>

" Fuzzy finder
set rtp+=/usr/local/bin/fzf
nmap <Leader>f :Files<CR>

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

" Syntax highlighting
let g:go_highlight_structs = 1
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1

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
set completeopt=menuone,noinsert,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_trigger_on_delete = 1

" LSP
" lua require'lspconfig'.gopls.setup{}
lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}
 " Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
nnoremap <silent>gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent><c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent>gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent>K     <cmd>lua vim.lsp.buf.hover()<CR>

" Floaterm
let g:floaterm_autoclose = 1
nmap <Leader>t :FloatermToggle<CR>

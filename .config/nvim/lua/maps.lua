-- Simple function to map keymap, non-recursive way
local function map_key(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

-- Jump to previous buffer
map_key('n', 'H', '<C-^>')

-- NVIM-tree
map_key('n', '<leader>n', ':NvimTreeFindFileToggle<CR>')

-- LazyGit
map_key('n', '<leader>gg', ':LazyGit<CR>')

-- Fugitive
map_key('n', '<leader>gs', ':Git<cr>')
map_key('n', '<leader>gbl', ':Git blame<cr>')
map_key('n', '<leader>gbr', ':GBrowse<cr>')
map_key('n', '<leader>gd', ':Gdiff<cr>')
map_key('n', '<leader>gps', ':Git push<cr>')
map_key('n', '<leader>gpl', ':Git pull<cr>')

-- vim-markdown
map_key('n', '<leader>md', ':Toch<cr>')

-- Go to the beginning of the line in insert mode
map_key('i', '<C-a>', '<C-o>0')
-- Go to the ending of the line in insert mode
map_key('i', '<C-b>', '<C-o>$')
-- Yank from the system clipboard(in normal mode)
map_key('n', '<leader>y', '"*y')
-- Yank from the system clipboard(in visual mode)
map_key('v', '<leader>y', '"*y')
-- Cut from the system clipboard(in normal mode)
map_key('n', '<leader>x', '"*x')
-- Cut from the system clipboard(in visual mode)
map_key('v', '<leader>x', '"*x')
-- Paste from the system clipboard(in normal mode)
map_key('n', '<leader>p', '"*p')
-- Paste from the system clipboard(in visual mode)
map_key('n', '<leader>p', '"*p')

-- Toggle search highlight
-- map_key('n', '<silent><C-C>', ':if (&hlsearch == 1) \| set nohlsearch \| else \| set hlsearch \| endif<cr>')
-- Do not make Q go to ex-mode
map_key('n', 'Q', '<Nop>')

-- Wrap selection with ''
map_key('v', '<leader>', "<esc>`>a'<esc>`<i'<esc>')")
-- Wrap selection with ""
map_key('v', '<leader>"', '<esc>`>a"<esc>`<i"<esc>')
-- Wrap selection with ()
map_key('v', '<leader>(', '<esc>`>a)<esc>`<i(<esc>')
-- Wrap selection with []
map_key('v', '<leader>[', '<esc>`>a]<esc>`<i[<esc>')
-- Wrap selection with {}
map_key('v', '<leader>{', '<esc>`>a}<esc>`<i{<esc>')

-- Use tab/shift-tab to navigate dropdowns
map_key('i', '<expr><TAB>', 'pumvisible() ? "\\<C-n>" : "\\<TAB>"')
map_key('i', '<expr><S-TAB>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"')

-- LSP
-- References
map_key('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
-- Implementation
map_key('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
-- definition
map_key('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- Show hovering documentation
map_key('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
-- Rename symbols
map_key('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>')

-- Show full error
map_key('n', 'ge', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>')

-- Jump between errors
map_key('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>')
map_key('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

-- Toggle error menu
map_key('n', '<leader>h', ':TroubleToggle<CR>')

-- Testing
map_key('n', '<Leader>tf', ':TestFile<CR>')
map_key('n', '<Leader>ts', ':TestSuite<CR>')
map_key('n', '<Leader>vi', ':VimuxInspectRunner<CR>')

-- Searching
map_key('n', '<leader>rg', ':FzfLua live_grep_glob<CR>')
map_key('n', '<leader>rG', ':FzfLua live_grep_resume<CR>')
map_key('n', '<leader>rw', ':FzfLua grep_cword<CR>')
map_key('n', '<Leader>f', ':FzfLua files<CR>')
map_key('n', '<Leader>b', ':FzfLua buffers<CR>')

-- Replacing
map_key('n', '<leader>sr', ':%s/<C-R><C-W>//g<Left><Left>')

-- Quick close
map_key('n', '<leader><leader>', ':x<cr>')

-- Yank to end
map_key('n', 'Y', 'y$')

-- Keep things centered
map_key('n', 'n', 'nzzzv')
map_key('n', 'N', 'Nzzzv')
map_key('n', 'J', 'mzJ`z')

-- Better break points
map_key('i', ',', ',<c-g>u')
map_key('i', '.', '.<c-g>u')
map_key('i', '!', '!<c-g>u')
map_key('i', '?', '?<c-g>u')

-- Better text movement
map_key('v', 'J', ':m >+1<CR>gv=gv')
map_key('v', 'K', ':m <-2<CR>gv=gv')
map_key('n', '<leader>j', ':m .+1<CR>==')
map_key('n', '<leader>k', ':m .-2<CR>==')

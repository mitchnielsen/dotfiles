-- Simple function to map keymap, non-recursive way
local function map_key(mode, lhs, rhs)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

-- Jump to previous buffer
map_key('n', 'H', '<C-^>')

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

-- Show full error
map_key('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>')

-- Jump between errors
map_key('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>')
map_key('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>')

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

-- Lazy utils
map_key('n', '<leader>lg', '<cmd>lua require("lazy.util").float_term("lazygit")<CR>')
map_key('n', '<leader>t',  '<cmd>lua require("lazy.util").float_term()<CR>')

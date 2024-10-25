-- Simple function to map keymap, non-recursive way
local function map_key(mode, lhs, rhs, desc)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { desc=desc or "", noremap = true, silent = true })
end

-- Line jumping
map_key('i', '<C-a>', '<C-o>0', 'go to end of line in insert mode')
map_key('i', '<C-e>', '<C-o>$', 'go to beginning of line in insert mode')

-- Copy/paste
map_key('n', '<leader>y', '"*y', 'yank to the system clipboard')
map_key('v', '<leader>y', '"*y', 'yank to the system clipboard')
map_key('n', '<leader>x', '"*x', 'cut to the system clipboard')
map_key('v', '<leader>x', '"*x', 'cut to the system clipboard')
map_key('n', '<leader>p', '"*p', 'paste from the system clipboard')
map_key('n', '<leader>p', '"*p', 'paste from the system clipboard')
map_key('n', 'Y', 'y$', 'yank to end of line')

-- Wrapping
map_key('v', "<leader>'", "<esc>`>a'<esc>`<i'<esc>')", "wrap selection with '")
map_key('v', '<leader>"', '<esc>`>a"<esc>`<i"<esc>', 'wrap selection with ""')
map_key('v', '<leader>(', '<esc>`>a)<esc>`<i(<esc>', 'wrap selection with ()')
map_key('v', '<leader>[', '<esc>`>a]<esc>`<i[<esc>', 'wrap selection with []')
map_key('v', '<leader>{', '<esc>`>a}<esc>`<i{<esc>', 'wrap selection with {}')

-- folding
map_key('n', '_', '<cmd>foldclose<CR>', 'close fold')
map_key('n', '+', '<cmd>foldopen<CR>', 'open fold')
map_key('n', '-', 'zM', 'close fold')
map_key('n', '=', 'zR', 'open fold')

-- Replacing
map_key('n', '<leader>rr', ':%s/<C-R><C-W>//g<Left><Left>', 'replace word under cursor')

-- Better break points
map_key('i', ',', ',<c-g>u')
map_key('i', '.', '.<c-g>u')
map_key('i', '!', '!<c-g>u')
map_key('i', '?', '?<c-g>u')

-- https://github.com/tpope/vim-unimpaired
map_key('n', '[q', '<cmd>cprev<CR>', 'prev quickfix entry')
map_key('n', ']q', '<cmd>cnext<CR>', 'next quickfix entry')
map_key('n', '[b', '<cmd>bprev<CR>', 'prev buffer')
map_key('n', ']b', '<cmd>bnext<CR>', 'next buffer')

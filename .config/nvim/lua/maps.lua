-- Simple function to map keymap, non-recursive way
local function map_key(mode, lhs, rhs, desc)
  vim.api.nvim_set_keymap(mode, lhs, rhs, { desc = desc or "", noremap = true, silent = true })
end

-- Line jumping
map_key("i", "<C-a>", "<C-o>0", "go to end of line in insert mode")
map_key("i", "<C-e>", "<C-o>$", "go to beginning of line in insert mode")

-- Copy/paste
map_key("n", "<leader>y", '"*y', "yank to the system clipboard")
map_key("v", "<leader>y", '"*y', "yank to the system clipboard")
map_key("n", "<leader>x", '"*x', "cut to the system clipboard")
map_key("v", "<leader>x", '"*x', "cut to the system clipboard")
map_key("n", "<leader>p", '"*p', "paste from the system clipboard")
map_key("n", "<leader>p", '"*p', "paste from the system clipboard")
map_key("n", "Y", "y$", "yank to end of line")

-- Wrapping
map_key("v", "<leader>'", "<esc>`>a'<esc>`<i'<esc>')", "wrap selection with '")
map_key("v", '<leader>"', '<esc>`>a"<esc>`<i"<esc>', 'wrap selection with ""')
map_key("v", "<leader>(", "<esc>`>a)<esc>`<i(<esc>", "wrap selection with ()")
map_key("v", "<leader>[", "<esc>`>a]<esc>`<i[<esc>", "wrap selection with []")
map_key("v", "<leader>{", "<esc>`>a}<esc>`<i{<esc>", "wrap selection with {}")

-- folding
map_key("n", "_", "<cmd>foldclose<CR>", "close fold")
map_key("n", "+", "<cmd>foldopen<CR>", "open fold")
map_key("n", "-", "zM", "close fold")
map_key("n", "=", "zR", "open fold")

-- formatting
map_key("n", "<leader>=", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "format code")

-- Replacing
map_key("n", "<leader>rr", ":%s/<C-R><C-W>//g<Left><Left>", "replace word under cursor")

-- Better break points
map_key("i", ",", ",<c-g>u")
map_key("i", ".", ".<c-g>u")
map_key("i", "!", "!<c-g>u")
map_key("i", "?", "?<c-g>u")

-- Searching
map_key("x", "/", "<Esc>/\\%V", "Search within visual selection")

-- neovide
if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

-- Line jumping
map("i", "<C-a>", "<C-o>0", "go to beginning of line")
map("i", "<C-e>", "<C-o>$", "go to end of line")
map("n", "<C-d>", "5<C-d>", "jump down 5 lines")
map("n", "<C-u>", "5<C-u>", "jump up 5 lines")

-- Color scheme
map("n", "<leader>cs", "<cmd>FzfLua colorschemes<cr>", "change color scheme")

-- Copy/paste
map({ "n", "x" }, "<leader>y", '"+y', "yank to the system clipboard")
map({ "n", "x" }, "<leader>x", '"+x', "cut to the system clipboard")
map({ "n", "x" }, "<leader>p", '"+p', "paste from the system clipboard")

-- Buffers
map("n", "<leader>d", "<cmd>bd<cr>", "delete buffer")
map("n", "<leader>yr", function()
  vim.fn.setreg("+", vim.fn.expand("%:~:."))
end, "copy relative path")
map("n", "<leader>yf", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, "copy full path")

-- Folding
map("n", "_", "<cmd>foldclose<cr>", "close fold")
map("n", "+", "<cmd>foldopen<cr>", "open fold")
map("n", "-", "zM", "close all folds")
map("n", "=", "zR", "open all folds")

-- Replacing
map("n", "<leader>rr", ":%s/<C-R><C-W>//g<Left><Left>", "replace word under cursor")

-- Spelling
map("n", "<leader>?", "<cmd>setlocal spell!<cr>", "toggle spell checking")
map("i", "<C-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u", "fix previous spelling mistake")

-- Add undo breakpoints after punctuation.
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", "!", "!<c-g>u")
map("i", "?", "?<c-g>u")

-- Keep the selection after indenting.
map("x", "<", "<gv")
map("x", ">", ">gv")

map("x", "/", "<Esc>/\\%V", "search within visual selection")

if vim.g.neovide then
  map("n", "<D-s>", "<cmd>write<cr>", "save")
  map("x", "<D-c>", '"+y', "copy")
  map("n", "<D-v>", '"+P', "paste")
  map("x", "<D-v>", '"+P', "paste")
  map("c", "<D-v>", "<C-R>+", "paste")
  map("i", "<D-v>", '<Esc>l"+Pli', "paste")
end

-- https://neovim.io/doc/user/autocmd.html

vim.api.nvim_create_autocmd("VimResized", {
  pattern = '*',
  command = 'tabdo wincmd = | lua require("fzf-lua").redraw()'
})

local autocmd = vim.api.nvim_create_autocmd

-- Don't auto-comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
  group = vim.api.nvim_create_augroup("Highlight", { clear = true }),
})

-- Filetype-based mappings
vim.cmd("autocmd Filetype gitcommit setlocal spell textwidth=72")
vim.cmd("autocmd BufNewFile,BufRead Dockerfile* set syntax=Dockerfile")
vim.cmd("autocmd BufNewFile,BufRead Dangerfile set syntax=ruby")
vim.cmd("autocmd BufNewFile,BufRead *.tpl set syntax=yaml")
vim.cmd("autocmd BufNewFile,BufRead *.yaml set syntax=yaml")
vim.cmd("autocmd BufNewFile,BufRead *.yml set syntax=yaml")

autocmd("FileType", {
  pattern = "Makefile.*",
  command = vim.cmd("setlocal noexpandtab")
})

autocmd("FileType", {
  pattern = "Makefile.*",
  command = vim.cmd("setlocal noexpandtab")
})

autocmd("FileType", {
  pattern = "*.go",
  command = vim.cmd("autocmd FileType sh map <leader>r :w<CR>:exec '!/bin/bashh' shellescape(@%, 1)<CR>"),
})

autocmd("FileType", {
  pattern = "*.rb",
  command = vim.cmd("autocmd FileType ruby map <leader>r :w<CR>:exec '!ruby' shellescape(@%, 1)<CR>"),
})

autocmd("FileType", {
  pattern = "*.py",
  command = vim.cmd("autocmd FileType python map <leader>r :w<CR>:exec '!python3' shellescape(@%, 1)<CR>")
})

autocmd("FileType", {
  pattern = "*.go",
  command = vim.cmd("autocmd FileType go map <leader>r :w<CR>:exec '!go run' shellescape(@%, 1)<CR>")
})

autocmd("FileType", {
  pattern = "*.go",
  command = vim.cmd("autocmd FileType go map <leader>t :w<CR>:exec '!go test'<CR>")
})

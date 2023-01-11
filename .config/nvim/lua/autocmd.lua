-- https://neovim.io/doc/user/autocmd.html

-- https://github.com/ibhagwan/fzf-lua/pull/505/files
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

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.tpl", "*.yaml", "*.yml" },
  command = "set syntax=yaml",
  group = vim.api.nvim_create_augroup("YAML", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.dockerfile", "Dockerfile.*" },
  command = "set syntax=dockerfile",
  group = vim.api.nvim_create_augroup("Dockerfile", { clear = true }),
})

autocmd("FileType", {
  pattern = { "*.txt", "*.md", "gitcommit", "gitrebase" },
  command = "setlocal spell textwidth=72",
  group = vim.api.nvim_create_augroup("Spell", { clear = true }),
})

autocmd("FileType", {
  pattern = "Makefile.*",
  command = vim.cmd("setlocal noexpandtab")
})

autocmd("FileType", {
  pattern = "*.go",
  command = vim.cmd("autocmd FileType sh map <leader>r :w<CR>:exec '!/bin/bash' shellescape(@%, 1)<CR>"),
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

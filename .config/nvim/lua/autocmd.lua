-- https://neovim.io/doc/user/autocmd.html

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Run gofmt + goimport on save
autocmd("BufWritePre", {
  pattern = "*.go",
  -- command = "silent! lua require('go.format').goimport()",
  callback = function()
    require('go.format').goimport()
  end,
  group = augroup("gofmt", { clear = true }),
})

-- https://github.com/ibhagwan/fzf-lua/pull/505/files
autocmd("VimResized", {
  pattern = '*',
  command = 'tabdo wincmd = | lua require("fzf-lua").redraw()'
})

-- Don't auto-comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
  group = augroup("Highlight", { clear = true }),
})

-- Filetype-based mappings

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.tpl", "*.yaml", "*.yml" },
  command = "set syntax=yaml",
  group = augroup("YAML", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.dockerfile", "Dockerfile.*" },
  command = "set syntax=dockerfile",
  group = augroup("Dockerfile", { clear = true }),
})

autocmd("FileType", {
  pattern = { "*.txt", "*.md", "gitcommit", "gitrebase" },
  command = "setlocal spell textwidth=72 comments=fb:>,fb:*,fb:+,fb:-",
  group = augroup("Spell", { clear = true }),
})

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
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

autocmd("BufWritePre", {
  pattern = {"*.tf", "*.tfvars"},
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- https://neovim.io/doc/user/autocmd.html

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Don't auto-comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Set up custom filetypes before plugins load for LSP to load correct providers
vim.filetype.add({
  filename = {
    ["go.work"] = "gowork",
  },
  extension = {
    tmpl = "gotmpl",
  },
})

-- Filetype-based mappings

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.tpl", "*.yaml", "*.yml" },
  command = "set syntax=yaml",
  group = augroup("YAML", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.json", "*.jsonc", "*.jsonnet" },
  command = "set syntax=json",
  group = augroup("JSON", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "config", "*.tfrc", ".terraformrc" },
  command = "set syntax=config",
  group = augroup("config", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "*.md.tmpl" },
  command = "set syntax=markdown",
  group = augroup("markdown", { clear = true }),
})

autocmd("FileType", {
  pattern = { "*.txt", "*.md", "gitcommit", "gitrebase" },
  command = "setlocal spell textwidth=72 comments=fb:>,fb:*,fb:+,fb:-",
  group = augroup("Spell", { clear = true }),
})

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})

-- Adjust to Makefile's weird use of tabs.
autocmd("FileType", {
  pattern = "Makefile.*",
  command = vim.cmd("setlocal noexpandtab"),
})

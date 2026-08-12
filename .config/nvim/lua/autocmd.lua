-- https://neovim.io/doc/user/autocmd.html

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Don't auto-comment new lines
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- Set up custom filetypes before plugins load so LSPs attach correctly.
vim.filetype.add({
  extension = {
    tmpl = "gotmpl",
  },
})

-- Syntax overrides

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = "*.tpl",
  command = "set syntax=yaml",
  group = augroup("YAML", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = "*.jsonnet",
  command = "set syntax=json",
  group = augroup("JSON", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = { "config", "*.tfrc", ".terraformrc" },
  command = "set syntax=config",
  group = augroup("config", { clear = true }),
})

autocmd({ "BufNewFile", "BufEnter" }, {
  pattern = "*.md.tmpl",
  command = "set syntax=markdown",
  group = augroup("markdown", { clear = true }),
})

local spell_filetypes = {
  gitcommit = true,
  gitrebase = true,
  markdown = true,
  text = true,
}
local spell_group = augroup("Spell", { clear = true })

autocmd("FileType", {
  pattern = vim.tbl_keys(spell_filetypes),
  command = "setlocal textwidth=72 comments=fb:>,fb:*,fb:+,fb:-",
  group = spell_group,
})

autocmd({ "FileType", "BufWinEnter" }, {
  callback = function()
    vim.wo.spell = spell_filetypes[vim.bo.filetype] or false
  end,
  group = spell_group,
})

-- Use internal formatting for bindings like gq.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].formatexpr = nil
  end,
})

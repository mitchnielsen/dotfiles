local vim = vim
local g = vim.g
local opt = vim.opt

-- Leader
g.mapleader = " "

-- Decorations
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.timeoutlen = 400
opt.pumheight = 20
opt.foldmethod = "manual"

-- Spacing
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.softtabstop = 2
opt.smartindent = true
opt.autoindent = true

-- Editing
opt.number = true
opt.relativenumber = true
opt.showmode = false
-- opt.termguicolors = true
opt.encoding = "UTF-8"
opt.fileformat = "unix"
opt.autoread = true -- reload files changed outside of vim
opt.ruler = true
opt.laststatus = 2
opt.paste = false
opt.errorbells = false
opt.mouse = "a"
opt.hidden = true
opt.swapfile = false
opt.backspace = "indent,eol,start"
opt.scrolloff = 5
opt.showcmd = true
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.wildmenu = true -- Autocomplete filenames
opt.wildignore = "*.o,*.hi,*.pyc"
opt.updatetime = 100 -- Git gutter
opt.splitbelow = true
opt.splitright = true
opt.compatible = false
opt.diffopt = "vertical"
opt.cursorline = true

local disabled_built_ins = {
  -- "netrw",
  -- "netrwPlugin",
  -- "netrwSettings",
  -- "netrwFileHandlers",
  -- "gzip",
  -- "zip",
  -- "zipPlugin",
  -- "tar",
  -- "tarPlugin",
  -- "getscript",
  -- "getscriptPlugin",
  -- "vimball",
  -- "vimballPlugin",
  -- "2html_plugin",
  -- "logipat",
  -- "rrhelper",
  -- "spellfile_plugin",
  -- "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

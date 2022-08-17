local vim = vim
local opt = vim.opt

-- Decorations
opt.signcolumn = "yes"
opt.cmdheight = 0
opt.timeoutlen = 400
opt.pumheight = 20
opt.foldmethod = "manual"
opt.list = true
opt.listchars = { tab = '▸ ', trail = '·'}
opt.fillchars:append { eob = " " } -- hide EndOfBuffer
vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
vim.cmd([[match ExtraWhitespace /\s\+$/]])

-- Spacing
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.softtabstop = 2
opt.smartindent = true

-- Editing
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.fileformat = "unix"
opt.laststatus = 0
opt.paste = false
opt.errorbells = false
opt.mouse = "a"
opt.swapfile = false
opt.scrolloff = 5
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit" -- see subsitutions in realtime
opt.wildmenu = true -- Autocomplete filenames
opt.wildignore = "*.o,*.hi,*.pyc"
opt.updatetime = 100 -- update interval for gitsigns
opt.splitbelow = true
opt.splitright = true
opt.diffopt = "vertical"
opt.cursorline = true
opt.conceallevel = 2

local disabled_built_ins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

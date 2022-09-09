local options = {
  -- Decorations
  signcolumn = "yes",
  cmdheight = 0,
  timeoutlen = 400,
  pumheight = 20,
  foldmethod = "manual",
  list = false,
  listchars = { tab = '▸ ', trail = '·'},

  -- Spacing,
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  softtabstop = 2,
  smartindent = true,

  -- Editing,
  termguicolors = true,
  number = true,
  relativenumber = true,
  showmode = false,
  fileformat = "unix",
  laststatus = 0,
  paste = false,
  errorbells = false,
  mouse = "a",
  swapfile = false,
  scrolloff = 5,
  showmatch = true,
  ignorecase = true,
  smartcase = true,
  inccommand = "nosplit", -- see subsitutions in realtime
  wildmenu = true, -- Autocomplete filenames,
  wildignore = "*.o,*.hi,*.pyc",
  updatetime = 100, -- update interval for gitsigns
  splitbelow = true,
  splitright = true,
  diffopt = "vertical",
  cursorline = true,
  conceallevel = 2,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Hide EndOfBuffer
vim.opt.fillchars:append { eob = " " }

-- Highlight trailing whitespace in red
vim.cmd([[highlight ExtraWhitespace ctermbg=red guibg=red]])
vim.cmd([[match ExtraWhitespace /\s\+$/]])

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

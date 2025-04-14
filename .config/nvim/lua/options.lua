local options = {
  -- Decorations
  signcolumn = "yes:2",
  cmdheight = 2,
  timeoutlen = 400,
  pumheight = 20,
  list = false,
  listchars = { tab = '▸ ', trail = '·'},

  -- Spacing,
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  softtabstop = 2,
  smartindent = true,
  breakindent = true,

  -- Editing,
  termguicolors = true,
  number = true,
  relativenumber = false,
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
  conceallevel = 0,

  -- folding
  -- https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim
  foldmethod = "expr", -- manual, indent
  foldexpr = "v:lua.vim.treesitter.foldexpr()",
  foldcolumn = "0", -- don't create a column to show fold status
  foldtext = "",
  foldlevel = 99,
  foldlevelstart = 0, -- keep folds open between buffers
  foldnestmax = 4,
  foldenable = false, -- closed on start
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Hide EndOfBuffer
vim.opt.fillchars:append { eob = " " }

-- Hide built-in themes
vim.opt.wildignore:append({
  "blue.vim",
  "darkblue.vim",
  "delek.vim",
  "desert.vim",
  "elflord.vim",
  "evening.vim",
  "habamax.vim",
  "industry.vim",
  "koehler.vim",
  "lunaperche.vim",
  "morning.vim",
  "murphy.vim",
  "pablo.vim",
  "peachpuff.vim",
  "quiet.vim",
  "retrobox.vim",
  "ron.vim",
  "shine.vim",
  "slate.vim",
  "sorbet.vim",
  "torte.vim",
  "unokai.vim",
  "vim",
  "vim.vim",
  "wildcharm.vim",
  "zaibatsu.vim",
  "zellner.vim",
})

-- Configure Python executable
vim.g.python3_host_prog = "/Users/mitch/bin/mise-python"

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

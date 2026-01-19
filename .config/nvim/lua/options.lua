-- To see current options:
--   1. Launch nvim: `nvim -V1`
--   2. Run a command like: `:verbose highlight SpellBad`

local options = {
  -- Decorations
  signcolumn = "yes:2",
  cmdheight = 2,
  timeoutlen = 400,
  pumheight = 20,
  list = true,
  listchars = { tab = "▸ ", trail = "·" },
  winborder = "rounded",
  shortmess = "CFOSWaco", -- Disable some built-in completion messages

  -- Spacing
  shiftwidth = 2,
  tabstop = 2,
  expandtab = true,
  softtabstop = 2,
  smartindent = true,
  breakindent = true,
  breakindentopt = "list:-1", -- Add padding for lists (if 'wrap' is set)
  autoindent = true,

  -- Editing
  termguicolors = true,
  number = true,
  relativenumber = false,
  showmode = false,
  fileformat = "unix",
  paste = false,
  errorbells = false,
  mouse = "a",
  swapfile = false,
  scrolloff = 5,
  showmatch = true,
  ignorecase = true,
  smartcase = true,
  infercase = true, -- Infer case in built-in completion
  inccommand = "nosplit", -- see subsitutions in realtime
  wildmenu = true, -- Autocomplete filenames,
  wildignore = "*.o,*.hi,*.pyc",
  updatetime = 100, -- update interval for gitsigns
  splitbelow = true,
  splitright = true,
  diffopt = "vertical",
  cursorline = true,
  cursorlineopt = "screenline,number", -- Highlight per screen line and number
  cursorcolumn = false,
  conceallevel = 0,
  iskeyword = "@,48-57,192-255", -- Characters that form keywords (includes dash)

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

  -- Limit ShaDa file size for faster startup
  shada = "'100,<50,s10,:1000,/100,@100,h",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Hide EndOfBuffer
vim.opt.fillchars:append({ eob = " " })

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

-- Show terminal how to render certain icons
vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Enable spell check
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }
vim.opt.spelloptions = "camel" -- Treat camelCase as separate words for spell checking

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

-- To see current options:
--   1. Launch nvim: `nvim -V1`
--   2. Run a command like: `:verbose highlight SpellBad`

local options = {
  -- Decorations
  signcolumn = "yes:2",
  cmdheight = 2,
  timeoutlen = 400,
  pumheight = 20,
  pumborder = "rounded",
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

  -- Editing
  termguicolors = true,
  number = true,
  showmode = false,
  formatoptions = "rqnl1j", -- Improve comment editing
  mouse = "a",
  swapfile = false,
  scrolloff = 5,
  showmatch = true,
  ignorecase = true,
  smartcase = true,
  infercase = true, -- Infer case in built-in completion
  wildignore = "*.o,*.hi,*.pyc",
  splitbelow = true,
  splitright = true,
  cursorline = true,
  cursorlineopt = "screenline,number", -- Highlight per screen line and number
  splitkeep = "screen", -- Reduce scroll during window split

  -- Pattern for a start of numbered list (used in `gw`). This reads as
  -- "Start of list item is: at least one special character (digit, -, +, *)
  -- possibly followed by punctuation (. or `)`) followed by at least one space".
  formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]],

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

  -- Disable termsync to work around rendering issues in Wezterm with multiplexing
  termsync = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.diffopt:append("vertical")
vim.opt.iskeyword:append("-")

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Hide EndOfBuffer
vim.opt.fillchars:append({
  eob = " ",
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})

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

-- Spell checking
vim.opt.spelllang = { "en_us" }
vim.opt.spelloptions = "camel" -- Treat camelCase as separate words for spell checking

local disabled_built_ins = {
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "2html_plugin",
  "spellfile_plugin",
  "matchit",
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- No configured plugins use remote providers.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

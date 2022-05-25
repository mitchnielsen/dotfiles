-- Inspiration taken from https://github.com/0xsamrath/kyoto.nvim

require("globals")
require("options")
require("lsp-config")
require("pluginList")

require("plugins.nightfox")
require("plugins.nvim-cmp")
require("plugins.context")
require("plugins.fzf")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.null-ls")
require("plugins.nvim-tree")
require("plugins.treesitter")
require("plugins.trouble")

vim.cmd("source ~/.config/nvim/viml/autocmd.vim")
vim.cmd("source ~/.config/nvim/viml/lets.vim")
vim.cmd("source ~/.config/nvim/viml/maps.vim")
vim.cmd("source ~/.config/nvim/viml/theme.vim")
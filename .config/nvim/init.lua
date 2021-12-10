require("globals")

-- autocomplete configuration
require("plugins.compe")
-- Langauge server configuration
require("lsp-config")
-- general configurations
require("options")
-- Git changes(showing in line number) configuration
require("plugins.gitsigns")
-- extra plugins(with shorter configs)
require("plugins.misc")
-- lualine
require("plugins.lualine")
-- lualine
require("plugins.context")
-- source our mappings last(may change)
vim.cmd("source ~/.config/nvim/viml/maps.vim")
-- auto-commands
vim.cmd("source ~/.config/nvim/viml/autocmd.vim")
-- let statements
vim.cmd("source ~/.config/nvim/viml/lets.vim")
-- theme
vim.cmd("source ~/.config/nvim/viml/theme.vim")

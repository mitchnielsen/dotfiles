vim.g.mapleader = " "

-- Core config (shared with nvim config via symlinks)
require("autocmd")
require("maps")
require("options")

-- Plugins are declared and configured in plugin/*.lua files.
-- They are sourced automatically by Neovim in alphabetical order.
-- Each file calls vim.pack.add() for its own plugins and runs setup.

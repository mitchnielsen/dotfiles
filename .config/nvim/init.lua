vim.g.mapleader = " "

-- Core config (shared with nvim config via symlinks)
require("autocmd")
require("maps")
require("options")

-- Experimental: new cmdline/message UI
-- 1. Fewer "Press ENTER" interruptions. Messages that exceed cmdheight get "collapsed" with a [+x] spill indicator instead of blocking you. Press
-- ENTER after a command or g< anytime to see the full message.
-- 2. Warnings don't block. Things like "Changing a readonly file" flash without requiring input.
-- 3. Cmdline highlights as you type. Live syntax highlighting in the command line.
-- 4. Messages show in a proper buffer/window instead of the legacy message grid.
--
-- g< or ENTER after a command shows the pager window.
-- To dismiss it, just press q or <Esc>.
require("vim._core.ui2").enable({})

-- Plugins are declared and configured in plugin/*.lua files.
-- They are sourced automatically by Neovim in alphabetical order.
-- Each file calls vim.pack.add() for its own plugins and runs setup.

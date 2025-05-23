return {
  "goolord/alpha-nvim",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local num_plugins_loaded = require("lazy").stats().loaded

    dashboard.section.header.val = { "nvim" }

    dashboard.section.buttons.val = {
      dashboard.button("e", "New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "Find file", ":FzfLua files<CR>"),
      dashboard.button("r", "Recent", ":FzfLua oldfiles<CR>"),
      dashboard.button("g", "Grep", ":FzfLua live_grep_glob<CR>"),
      dashboard.button("l", "Lazy", ":Lazy<CR>"),
      dashboard.button("s", "Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
      dashboard.button("q", "Quit", ":qa<CR>"),
    }

    dashboard.section.footer.val = "Loaded " .. num_plugins_loaded .. " plugins"

    dashboard.opts.layout = {
      { type = "padding", val = 5 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 0 },
      dashboard.section.bottom_section,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.opts)
  end,
}

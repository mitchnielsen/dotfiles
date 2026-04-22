local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

local keys = require("keys")
local colors = require("colors")

-- Appearance
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.window_decorations = "RESIZE"
config.max_fps = 120
config.enable_scroll_bar = false
config.window_padding = {
  left = 15,
  right = 15,
  top = 15,
  bottom = 15,
}

-- Font
--   wezterm ls-fonts --list-system
--   fc-list
config.font = wezterm.font("SFMono Nerd Font")
config.font_size = 12.0
config.line_height = 1.25
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Configure multiplexing to save workspaces
-- when quitting and reopening Wezterm.
config.unix_domains = {
  {
    name = "unix",
  },
}

-- Tab bar: show workspace name on the right (like tmux session name)
wezterm.on("update-right-status", function(window, _)
  window:set_right_status(wezterm.format({
    { Background = { Color = "#efefed" } },
    { Foreground = { Color = "#0969da" } },
    { Text = " " .. window:active_workspace() .. " " },
  }))
end)

keys.setup(config)
colors.setup(config)

return config

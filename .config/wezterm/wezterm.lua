local helpers = require("helpers")
local wezterm = require("wezterm")
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = "OneHalfDark"

-- Match the 'cool' variant of onedark theme
config.colors = {
  background = "#242b38",
  cursor_fg = "#242b38",
  cursor_border = "#242b38",
}

-- wezterm ls-fonts
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12.5
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.enable_tab_bar = false
config.window_decorations = 'TITLE | RESIZE'

wezterm.on("format-window-title", function()
  return "Terminal"
end)

config.enable_scroll_bar = false
config.window_padding = {
  left = 1,
  right = 1,
  top = 0,
  bottom = 1,
}

config.keys = {
  {
    key = "k",
    mods = "CMD",
    action = act.Multiple({
      act.SendString("clear"),
      act.SendKey({ key = "Enter" }),
    }),
  },
  {
    key = "]",
    mods = "CMD|SHIFT",
    action = act.Multiple({
      act.SendKey({ key = "B", mods = "CTRL" }),
      act.SendKey({ key = "N" }),
    }),
  },
  {
    key = "[",
    mods = "CMD|SHIFT",
    action = act.Multiple({
      act.SendKey({ key = "B", mods = "CTRL" }),
      act.SendKey({ key = "P" }),
    }),
  },
}

helpers.tmux_panes(config.keys)

return config

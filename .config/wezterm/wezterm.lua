local wezterm = require("wezterm")
local helpers = require("helpers")
local act = wezterm.action
local config = wezterm.config_builder()

config.max_fps = 120

config.color_scheme = "nordfox"

-- List available fonts:
--   wezterm ls-fonts --list-system
--   fc-list
config.font = wezterm.font("SFMono Nerd Font")
config.line_height = 1.25
config.font_size = 12.0
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

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

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- Appearance
config.color_scheme = "nordfox"
config.enable_tab_bar = false
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

-- Key bindings
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

-- Add bindings for changing tmux panes
for num = 0, 5 do
  table.insert(config.keys, {
    key = tostring(num),
    mods = "CMD",
    action = act.Multiple({
      act.SendKey({ key = "b", mods = "CTRL" }),
      act.SendKey({ key = tostring(num) }),
    }),
  })
end

return config

local helpers = require 'helpers'
local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'nordfox'

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14.0

config.enable_tab_bar = false
config.window_decorations = 'RESIZE'

config.keys = {
  {
    key = 'k',
    mods = 'CMD',
    action = act.Multiple {
      act.SendString "clear",
      act.SendKey { key = 'Enter' },
    }
  },
  {
    key = ']',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'B', mods = 'CTRL' },
      act.SendKey { key = 'N' },
    },
  },
  {
    key = '[',
    mods = 'CMD|SHIFT',
    action = act.Multiple {
      act.SendKey { key = 'B', mods = 'CTRL' },
      act.SendKey { key = 'P' },
    },
  },
}

helpers.tmux_panes(config.keys)

return config

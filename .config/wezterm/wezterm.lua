local helpers = require 'helpers'
local wezterm = require 'wezterm'
local act = wezterm.action
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'OneHalfDark'

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 13.0
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

config.enable_tab_bar = false
config.window_decorations = 'TITLE | RESIZE'

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

config.hyperlink_rules = {
  -- Linkify things that look like URLs and the host has a TLD name.
  --
  -- Compiled-in default. Used if you don't specify any hyperlink_rules.
  {
    regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
    format = "$0",
  },

  -- linkify email addresses
  -- Compiled-in default. Used if you don't specify any hyperlink_rules.
  {
    regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
    format = "mailto:$0",
  },

  -- file:// URI
  -- Compiled-in default. Used if you don't specify any hyperlink_rules.
  {
    regex = [[\bfile://\S*\b]],
    format = "$0",
  },

  -- Linkify things that look like URLs with numeric addresses as hosts.
  -- E.g. http://127.0.0.1:8000 for a local development server,
  -- or http://192.168.1.1 for the web interface of many routers.
  {
    regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
    format = "$0",
  },

  -- Make username/project paths clickable. This implies paths like the following are for GitHub.
  -- As long as a full URL hyperlink regex exists above this it should not match a full URL to
  -- GitHub or GitLab / BitBucket (i.e. https://gitlab.com/user/project.git is still a whole clickable URL)
  {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = "https://www.github.com/$1/$3",
  },
}

helpers.tmux_panes(config.keys)

return config

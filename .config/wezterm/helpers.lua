local module = {}

local wezterm = require 'wezterm'
local act = wezterm.action

function module.tmux_panes(keymap)
  for num=0,5 do
    table.insert(keymap, {
      key = tostring(num),
      mods = 'CMD',
      action = act.Multiple {
        act.SendKey { key = 'b', mods = 'CTRL' },
        act.SendKey { key = tostring(num) },
      }
    })
  end
end

return module

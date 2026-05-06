local wezterm = require("wezterm")
local config = wezterm.config_builder()
local M = {}

function M.setup(config)
  config.color_scheme = "clarity"
  config.color_schemes = {
    clarity = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/clarity.toml"),
  }

  -- Tab bar colors (clarity palette)
  config.colors = {
    tab_bar = {
      background = "#eeeeee",
      active_tab = {
        bg_color = "#f0f0f0",
        fg_color = "#24292f",
      },
      inactive_tab = {
        bg_color = "#eeeeee",
        fg_color = "#6e7781",
      },
      inactive_tab_hover = {
        bg_color = "#f0f0f0",
        fg_color = "#24292f",
      },
      new_tab = {
        bg_color = "#eeeeee",
        fg_color = "#6e7781",
      },
      new_tab_hover = {
        bg_color = "#f0f0f0",
        fg_color = "#24292f",
      },
    },
  }
end

return M

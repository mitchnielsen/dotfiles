local wezterm = require("wezterm")
local M = {}

local function is_dark()
  if wezterm.gui then
    local appearance = wezterm.gui.get_appearance()
    return appearance:find("Dark") ~= nil
  end
  return false
end

local function tab_bar_colors(dark)
  if dark then
    return {
      background = "#1e1e1e",
      active_tab = { bg_color = "#23262b", fg_color = "#e6edf3" },
      inactive_tab = { bg_color = "#1e1e1e", fg_color = "#7d8590" },
      inactive_tab_hover = { bg_color = "#23262b", fg_color = "#e6edf3" },
      new_tab = { bg_color = "#1e1e1e", fg_color = "#7d8590" },
      new_tab_hover = { bg_color = "#23262b", fg_color = "#e6edf3" },
    }
  end
  return {
    background = "#eeeeee",
    active_tab = { bg_color = "#f0f0f0", fg_color = "#24292f" },
    inactive_tab = { bg_color = "#eeeeee", fg_color = "#6e7781" },
    inactive_tab_hover = { bg_color = "#f0f0f0", fg_color = "#24292f" },
    new_tab = { bg_color = "#eeeeee", fg_color = "#6e7781" },
    new_tab_hover = { bg_color = "#f0f0f0", fg_color = "#24292f" },
  }
end

function M.setup(config)
  local dark = is_dark()
  config.color_scheme = dark and "clarity-dark" or "clarity-light"
  config.color_schemes = {
    ["clarity-light"] = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/clarity-light.toml"),
    ["clarity-dark"] = wezterm.color.load_scheme(wezterm.config_dir .. "/colors/clarity-dark.toml"),
  }
  config.colors = { tab_bar = tab_bar_colors(dark) }
end

return M

local wezterm = require("wezterm")
local config = wezterm.config_builder()

local keys = require("keys")
local colors = require("colors")

-- Terminal type: use wezterm's terminfo for proper damage tracking and
-- synchronized output (fixes stale-line artifacts in Neovim floats like FzfLua).
-- Requires `wezterm` terminfo to be installed (see ~/.terminfo or system-wide).
config.term = "wezterm"

-- Appearance
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.default_workspace = "home"
config.scrollback_lines = 3000
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
config.font_size = 14.0
config.line_height = 1.2
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- Configure multiplexing to save workspaces
-- when quitting and reopening Wezterm.
config.unix_domains = {
  {
    name = "unix",
  },
}

-- Automatically connect to the default unix domain.
config.default_gui_startup_args = { "connect", "unix" }

-- Tab bar: show workspace name on the right (like tmux session name)
wezterm.on("update-right-status", function(window, pane)
  local status = pane:get_current_working_dir().file_path .. " [" .. window:active_workspace() .. "]"
  window:set_right_status(status)
end)

-- Stable tab titles: prefer the user-set title, otherwise the spawned program's
-- argv[0]. Never fall back to the pane's live title (avoids flicker from apps
-- that update the terminal title continuously, e.g. Claude Code).
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local user_vars = tab.active_pane.user_vars or {}
  local title = user_vars.ws_title
  if not title or #title == 0 then
    title = tab.tab_title
  end
  if not title or #title == 0 then
    local process = tab.active_pane.foreground_process_name or ""
    title = process:match("([^/]+)$") or "shell"
  end
  local padded = " " .. title .. " "
  if #padded > max_width then
    padded = wezterm.truncate_right(padded, max_width)
  end
  return padded
end)

-- Hide the scrollbar when there is no scrollback or alternate screen is active
wezterm.on("update-status", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local dimensions = pane:get_dimensions()

  overrides.enable_scroll_bar = dimensions.scrollback_rows > dimensions.viewport_rows
    and not pane:is_alt_screen_active()

  window:set_config_overrides(overrides)
end)

keys.setup(config)
colors.setup(config)

return config

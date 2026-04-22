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

-- Leader key (Ctrl+B, like tmux)
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

-- Key bindings
config.keys = {
  -- Clear screen
  {
    key = "k",
    mods = "CMD",
    action = act.Multiple({
      act.SendString("clear"),
      act.SendKey({ key = "Enter" }),
    }),
  },
  -- Claude Code: shift+enter
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action({ SendString = "\x1b\r" }),
  },

  -- Panes: split (% = side-by-side, " = top/bottom)
  { key = "%", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = '"', mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- Panes: navigate
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Panes: resize
  { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- Panes: zoom and close
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

  -- Tabs (like tmux windows)
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Rename tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  { key = "&", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },

  -- Workspaces (like tmux sessions)
  { key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },
  {
    key = "$",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Rename workspace",
      action = wezterm.action_callback(function(_, _, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  {
    key = "w",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "New workspace name",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },

  -- Quick select (hint-style selection for URLs, paths, hashes, etc.)
  { key = "Tab", mods = "LEADER", action = act.QuickSelect },

  -- Copy mode and scrollback
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "u", mods = "LEADER", action = act.ScrollByPage(-0.5) },
  { key = "d", mods = "LEADER", action = act.ScrollByPage(0.5) },
}

-- Switch tabs by number (Ctrl+B 0-9, like tmux windows)
for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i),
  })
end

return config

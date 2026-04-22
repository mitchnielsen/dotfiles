local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local M = {}

function M.setup(config)
  -- Leader key (Ctrl+B, like tmux)
  config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

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
    { key = "i", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "i", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

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
    { key = "f", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

    -- Tabs (like tmux windows)
    { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "]", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
    { key = "[", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
    { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
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
end

return M

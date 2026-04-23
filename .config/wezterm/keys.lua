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

    -- command palette
    {
      key = "P",
      mods = "CMD",
      action = wezterm.action.ActivateCommandPalette,
    },

    -- Claude Code: shift+enter
    {
      key = "Enter",
      mods = "SHIFT",
      action = wezterm.action({ SendString = "\x1b\r" }),
    },

    -- Panes: split (% = side-by-side, " = top/bottom)
    { key = "s", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "i", mods = "CMD", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

    -- Panes: navigate
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

    -- Panes: resize
    { key = "H", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 10 }) },
    { key = "J", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 10 }) },
    { key = "K", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 10 }) },
    { key = "L", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 10 }) },

    -- Panes: zoom and close
    { key = "f", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },

    -- Tabs (like tmux windows)
    { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "]", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
    { key = "[", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
    -- { key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },
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
    { key = "o", mods = "CMD", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
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

    -- Dev environment setup: nvim / agent / lazygit / shell tabs
    {
      key = "x",
      mods = "CMD",
      action = wezterm.action_callback(function(window, pane)
        local cwd_uri = pane:get_current_working_dir()
        local cwd = cwd_uri and cwd_uri.file_path or nil
        local mux_window = window:mux_window()

        local shell = os.getenv("SHELL") or "/bin/zsh"

        -- Build a shell command that emits an OSC 1337 SetUserVar sequence
        -- for ws_title, then runs `cmd` (if any), then execs the shell.
        -- The user-var persists in pane.user_vars across process changes,
        -- so format-tab-title can read it to keep the tab label stable.
        local function build_args(title, cmd)
          local osc = "printf '\\033]1337;SetUserVar=ws_title=%s\\007' "
                   .. "\"$(printf '%s' '" .. title .. "' | base64)\""
          local tail = cmd and (cmd .. "; exec " .. shell) or ("exec " .. shell)
          return { shell, "-i", "-l", "-c", osc .. "; " .. tail }
        end

        -- Rename current tab and launch neovim in it
        mux_window:active_tab():set_title("nvim")
        pane:send_text(
          "printf '\\033]1337;SetUserVar=ws_title=%s\\007' "
          .. "\"$(printf '%s' nvim | base64)\" && nvim\n"
        )

        local function spawn_tab(title, cmd)
          local spawn_opts = { cwd = cwd, args = build_args(title, cmd) }
          local tab, _, _ = mux_window:spawn_tab(spawn_opts)
          tab:set_title(title)
        end

        spawn_tab("agent", "claude")
        spawn_tab("lazygit", "lazygit")
        spawn_tab("shell", nil)

        mux_window:active_tab():activate()
        -- Refocus the first (nvim) tab
        local tabs = mux_window:tabs()
        if tabs[1] then
          tabs[1]:activate()
        end
      end),
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

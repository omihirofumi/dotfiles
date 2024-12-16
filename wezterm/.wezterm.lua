-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = require "wezterm".action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Material (terminal.sexy)'
config.window_background_opacity = 0.9

config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }


config.keys = {
  {
    mods = 'LEADER',
    key = 's',
    action = act.ShowLauncherArgs { flags = 'WORKSPACES' , title = "Select workspace" },
  },
  {
    -- Rename workspace
    mods = 'LEADER',
    key = 'r',
    action = act.PromptInputLine {
      description = '(wezterm) Set workspace title:',
      action = wezterm.action_callback(function(win,pane,line)
        if line then
          wezterm.mux.rename_workspace(
            wezterm.mux.get_active_workspace(),
            line
          )
        end
      end),
    },
  },
  {
    -- Create new workspace
    mods = 'LEADER|SHIFT',
    key = 'S',
    action = act.PromptInputLine {
      description = "(wezterm) Create new workspace:",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
}



-- and finally, return the configuration to wezterm
return config

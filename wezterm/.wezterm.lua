-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = require "wezterm".action

-- This will hold the configuration.
local config = wezterm.config_builder()

local keys = {}

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.window_background_opacity = 0.9
config.color_scheme = 'Material (terminal.sexy)'

-- tab config
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = "" }
  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

  return current_dir == HOME_DIR and "." or string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2")
end

-- tab title
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local has_unseen_output = false
  if not tab.is_active then
    for _, pane in ipairs(tab.panes) do
      if pane.has_unseen_output then
        has_unseen_output = true
        break
      end
    end
  end

  local cwd = wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Text = get_current_working_dir(tab) },
  })

  local title = string.format(" [%s] %s", tab.tab_index + 1, cwd)

  if has_unseen_output then
    return {
      { Foreground = { Color = "#8866bb" } },
      { Text = title },
    }
  end

  return {
    { Text = title },
  }
end)
config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

-- -- workspaces
-- -- print the workspace name at the upper right
-- wezterm.on("update-right-status", function(window, pane)
--   window:set_right_status(window:active_workspace())
-- end)
-- -- load plugin
-- local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- -- set path to zoxide
-- workspace_switcher.zoxide_path = "/opt/homebrew/bin/zoxide"
-- -- keymaps
-- table.insert(keys, { key = "s", mods = "CTRL|SHIFT", action = workspace_switcher.switch_workspace() })
-- table.insert(keys, { key = "t", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) })
-- table.insert(keys, { key = "[", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(1) })
-- table.insert(keys, { key = "]", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) })




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

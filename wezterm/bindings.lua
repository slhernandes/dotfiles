local wezterm = require('wezterm')

local module = {}

local function set_leader(config)
  config.leader = {
    key = 'a',
    mods = 'ALT',
    timeout_milliseconds = 1000,
  }
end

local function set_binding(config)
  local act = wezterm.action
  config.keys = {
    {
      key = 'c',
      mods = 'LEADER',
      action = act.SpawnTab('CurrentPaneDomain'),
    },
    {
      key = 'v',
      mods = 'LEADER',
      action = act.SplitPane {
        direction = 'Right',
      },
    },
    {
      key = 'h',
      mods = 'LEADER',
      action = act.SplitPane {
        direction = 'Down',
      },
    },
    {
      key = 'n',
      mods = 'LEADER',
      action = act.ActivateTabRelative(1),
    },
    {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateTabRelative(-1),
    },
    {
      key = 'h',
      mods = 'ALT',
      action = act.ActivatePaneDirection('Left'),
    },
    {
      key = 'j',
      mods = 'ALT',
      action = act.ActivatePaneDirection('Down'),
    },
    {
      key = 'k',
      mods = 'ALT',
      action = act.ActivatePaneDirection('Up'),
    },
    {
      key = 'l',
      mods = 'ALT',
      action = act.ActivatePaneDirection('Right'),
    },
    {
      key = '[',
      mods = 'LEADER',
      action = act.ActivateCopyMode,
    },
    {
      key = 'z',
      mods = 'LEADER',
      action = act.ToggleFullScreen
    },
    {
      key = 'x',
      mods = 'LEADER',
      action = act.CloseCurrentPane { confirm = false },
    },
    {
      key = '&',
      mods = 'LEADER | SHIFT',
      action = act.CloseCurrentTab { confirm = false },
    },
  }
end

function module.set_bindings(config)
  set_leader(config)
  set_binding(config)
end

return module

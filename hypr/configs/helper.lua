local theme = require("themes.tokyonightstorm")
local module = {}

---@param direction string
---@param debug     boolean
---@return function moveWindow A function that moves active window to adjecent workspace cyclically
module.moveWindow = function(direction, debug)
  return function()
    local ws = hl.get_active_workspace()
    if ws ~= nil then
      local now = tonumber(ws.name)
      local prev = (now - 2) % 9 + 1
      local next = (now % 9) + 1
      if debug then
        hl.notification.create({
          text = "now: " .. tostring(now) .. ", prev: " .. tostring(prev) ..
              ", next: " .. tostring(next),
          duration = 5000
        })
      end
      local activeWindow = hl.get_active_window()
      if activeWindow ~= nil and activeWindow.group ~= nil then
        hl.dispatch(hl.dsp.window.move({out_of_group = true}))
      end
      if direction == "l" then
        hl.dispatch(hl.dsp.window.move({workspace = tostring(prev)}))
      elseif direction == "r" then
        hl.dispatch(hl.dsp.window.move({workspace = tostring(next)}))
      else
        hl.notification.create({text = "Unknown direction", duration = 5000})
      end
    else
      hl.notification.create({text = "Unknown workspace id", duration = 5000})
    end
  end
end

---@param app { name: string, key: string, layout: string, cmd: string | table }
---@return function namedSp A function that toggles the dropdown app of choice
module.namedSp = function(app)
  return function()
    local specialWs = hl.get_workspace("name:special:" .. app.name)
    if specialWs == nil then
      if app.layout ~= nil then
        hl.workspace_rule({
          workspace = "special:" .. app.name,
          layout = app.layout
        })
      end
      if type(app.cmd) == "string" then
        hl.exec_cmd(app.cmd, {
          workspace = "special:" .. app.name,
          focus_on_activate = true
        })
      elseif type(app.cmd) == "table" then
        for _, cmd in ipairs(app.cmd) do
          hl.exec_cmd(cmd, {
            workspace = "special:" .. app.name,
            group = "set",
            tag = "+" .. app.name
          })
        end
      else
        hl.notification.create({
          text = "Unreachable!:module.namedSp",
          duration = 3000,
          color = module.rgb(theme.color.red)
        })
      end
    else
      hl.dispatch(hl.dsp.workspace.toggle_special(app.name))
    end
  end
end

---@return string layout The layout name of current workspace
module.getActiveLayout = function()
  local currentSpecial = hl.get_active_special_workspace()
  local currentWorkspace = hl.get_active_workspace()
  local layout
  if currentSpecial ~= nil and currentSpecial.tiled_layout ~= nil then
    layout = currentSpecial.tiled_layout
  elseif currentWorkspace ~= nil and currentWorkspace.tiled_layout ~= nil then
    layout = currentWorkspace.tiled_layout
  end
  return layout
end

---@return string name The name of the active workspace (including special)
module.getActiveWorkspace = function()
  local currentSpecial = hl.get_active_special_workspace()
  local currentWorkspace = hl.get_active_workspace()
  local name
  if currentSpecial ~= nil and currentSpecial.name ~= nil then
    name = currentSpecial.name
  elseif currentWorkspace ~= nil and currentWorkspace.name ~= nil then
    name = currentWorkspace.name
  end
  return name
end

---@param io        "in"|"out"
---@param operation "up"|"down"|"mute"
---@return function | HL.Dispatcher volumeControl Either a amixer cmd to control volume or no_op
module.volume = function(io, operation)
  if io == "out" then
    if operation == "up" then
      return function()
        hl.exec_cmd(
            "amixer set Master on && amixer set Master 5%+ && qs ipc call volumeOSD openOSD true")
      end
    elseif operation == "down" then
      return function()
        hl.exec_cmd(
            "amixer set Master on && amixer set Master 5%- && qs ipc call volumeOSD openOSD true")
      end
    elseif operation == "mute" then
      return function()
        hl.exec_cmd(
            "amixer set Master 1+ toggle && qs ipc call volumeOSD openOSD true")
      end
    end
  elseif io == "in" then
    if operation == "up" then
      return function()
        hl.exec_cmd(
            "amixer cset name='Capture Switch' on && amixer set Capture 5%+ && qs ipc call volumeOSD openOSD false")
      end
    elseif operation == "down" then
      return function()
        hl.exec_cmd(
            "amixer cset name='Capture Switch' on && amixer set Capture 5%- && qs ipc call volumeOSD openOSD false")
      end
    elseif operation == "mute" then
      return function()
        hl.exec_cmd(
            "amixer set Capture 1+ toggle && qs ipc call volumeOSD openOSD false")
      end
    end
  end
  hl.notification.create({
    text = "Unreachable!:module.volume",
    duration = 3000,
    color = module.rgb(theme.color.red)
  })
  return hl.dispatch(hl.dsp.no_op())
end

---@return function masterTabbedToggle A function to toggle between regular master layout and tabbed layout (see xmonad for comparison)
module.masterTabbedToggle = function()
  return function()
    if hl.get_active_special_workspace() ~= nil then return end
    local currentWorkspace = hl.get_active_workspace()
    if currentWorkspace == nil or currentWorkspace.windows == 0 then return end
    if currentWorkspace.tiled_layout == "master" then
      if currentWorkspace.groups == 0 then
        local activeWindow = currentWorkspace.last_window.address
        local orientation = hl.get_config("master.orientation")
        hl.dispatch(hl.dsp.layout("focusmaster master"))
        hl.dispatch(hl.dsp.window.tag({tag = "mmaster"}))
        hl.dispatch(hl.dsp.group.toggle())
        if currentWorkspace.windows > 1 then
          for _ = 2, currentWorkspace.windows do
            hl.dispatch(hl.dsp.window.cycle_next({next = true}))
            if orientation == "left" then
              hl.dispatch(hl.dsp.window.move({into_group = "l"}))
            elseif orientation == "top" then
              hl.dispatch(hl.dsp.window.move({into_group = "u"}))
            end
          end
        end
        hl.dispatch(hl.dsp.focus({window = "address:" .. activeWindow}))
      else
        local activeWindow = currentWorkspace.last_window.address
        local windows = hl.get_windows({workspace = currentWorkspace})
        for _, v in ipairs(windows) do
          local groups = {}
          if v.group ~= nil and groups[v.group] == nil then
            groups[v.group] = 1
            hl.dispatch(hl.dsp.group.toggle({window = "address:" .. v.address}))
          end
          local tags
          if type(v.tags) == "string" then
            tags = {v.tags}
          elseif type(v.tags) == "table" then
            tags = v.tags
          else
            hl.notification({
              text = "Unreachable!:module.masterTabbedToggle",
              duration = 3000,
              color = module.rgb(theme.colour.red)
            })
          end
          for _, t in ipairs(tags) do
            if t == "mmaster" then
              hl.dispatch(hl.dsp.focus({window = "address:" .. v.address}))
              hl.dispatch(hl.dsp.layout("swapwithmaster ignoremaster"))
              hl.dispatch(hl.dsp.window.clear_tags({
                window = "address:" .. v.address
              }))
            end
          end
        end
        hl.dispatch(hl.dsp.focus({window = "address:" .. activeWindow}))
      end
    elseif currentWorkspace.tiled_layout == "scrolling" then
      local soloColumn = true
      local activeWindow = hl.get_active_window()
      local windows = currentWorkspace:get_windows()
      if activeWindow == nil then return end
      for _, w in ipairs(windows) do
        if w.address ~= activeWindow.address then
          if w.at.x == activeWindow.at.x then soloColumn = false end
        end
      end
      local full = false
      local expelled = false
      if activeWindow.tags ~= nil then
        if type(activeWindow.tags) == "string" then
          if string.gmatch(activeWindow.tags, "expelled")() ~= nil then
            expelled = true
          elseif string.gmatch(activeWindow.tags, "full")() ~= nil then
            full = true
          end
        elseif type(activeWindow.tags) == "table" then
          for _, v in ipairs(activeWindow.tags) do
            if string.gmatch(v, "expelled")() ~= nil then
              expelled = true
            elseif string.gmatch(v, "full")() ~= nil then
              full = true
            end
          end
        else
          hl.notification({
            text = "Unreachable!:module.masterTabbedToggle",
            duration = 3000,
            color = module.rgb(theme.colour.red)
          })
        end
      end
      if not soloColumn then
        hl.dispatch(hl.dsp.window.tag({tag = "+expelled"}))
        hl.dispatch(hl.dsp.window.tag({tag = "+full"}))
        hl.dispatch(hl.dsp.layout("promote"))
        hl.dispatch(hl.dsp.layout("colresize 1.0"))
      elseif expelled and full then
        hl.dispatch(hl.dsp.window.tag({tag = "-expelled"}))
        hl.dispatch(hl.dsp.window.tag({tag = "-full"}))
        hl.dispatch(hl.dsp.layout("colresize 0.5"))
        hl.dispatch(hl.dsp.layout("consume"))
      elseif full then
        hl.dispatch(hl.dsp.window.tag({tag = "-full"}))
        hl.dispatch(hl.dsp.layout("colresize 0.5"))
      elseif not expelled and not full then
        hl.dispatch(hl.dsp.window.tag({tag = "+full"}))
        hl.dispatch(hl.dsp.layout("colresize 1.0"))
      else
        hl.notification({
          text = "Unreachable!:module.masterTabbedToggle",
          duration = 3000,
          color = module.rgb(theme.colour.red)
        })
      end
    end
  end
end

---@param dl boolean cycle to down/left if true, else cycle to up/right
---@return function cycleWindow A function then cycles the window focus respecting the masterTabbed layout and floating window
module.cycleWindow = function(dl)
  return function()
    local cycle
    if dl then
      cycle = "next"
    else
      cycle = "prev"
    end

    local activeWindow = hl.get_active_window()
    local currentSpecial = hl.get_active_special_workspace()
    local currentWorkspace = hl.get_active_workspace()

    if activeWindow == nil then return end
    if activeWindow.floating then
      hl.dispatch(hl.dsp.window.cycle_next({next = dl, floating = true}))
    elseif activeWindow.group ~= nil then
      if dl then
        hl.dispatch(hl.dsp.group.prev())
      else
        hl.dispatch(hl.dsp.group.next())
      end
    else
      if currentSpecial == nil and currentWorkspace ~= nil and
          currentWorkspace.tiled_layout == "scrolling" then
        local windows = currentWorkspace:get_windows()
        local below = false
        local above = false
        for _, w in ipairs(windows) do
          if w.address ~= activeWindow.address then
            if w.at.x == activeWindow.at.x then
              if w.at.y < activeWindow.at.y then
                above = true
              elseif w.at.y > activeWindow.at.y then
                below = true
              end
            end
          end
        end
        if dl then
          if below then
            hl.dispatch(hl.dsp.layout("focus d"))
          else
            hl.dispatch(hl.dsp.layout("focus l"))
          end
        else
          if above then
            hl.dispatch(hl.dsp.layout("focus u"))
          else
            hl.dispatch(hl.dsp.layout("focus r"))
          end
        end
      else
        hl.dispatch(hl.dsp.layout("cycle" .. cycle))
      end
    end
  end
end

---@param next boolean
---@return function swapWindow A function then swaps the window with next/prev window respecting the masterTabbed layout
module.swapWindow = function(next)
  return function()
    if hl.get_active_special_workspace() ~= nil then
      if next then
        hl.dispatch(hl.dsp.layout("swapnext"))
      else
        hl.dispatch(hl.dsp.layout("swapprev"))
      end
      return
    end

    local workspace = hl.get_active_workspace()
    if workspace ~= nil and workspace.groups == 0 then
      if next then
        if workspace.tiled_layout == "scrolling" then
          hl.dispatch(hl.dsp.layout("consume_or_expel prev"))
        else
          hl.dispatch(hl.dsp.layout("swapnext"))
        end
      else
        if workspace.tiled_layout == "scrolling" then
          hl.dispatch(hl.dsp.layout("consume_or_expel next"))
        else
          hl.dispatch(hl.dsp.layout("swapprev"))
        end
      end
    elseif workspace ~= nil then
      local activeWindow = workspace.last_window
      if activeWindow ~= nil and not activeWindow.floating then
        hl.dispatch(hl.dsp.group.move_window({forward = next}))
      end
    else
      hl.notification.create({
        text = "Unreachable!:module.swapWindow",
        duration = 3000,
        color = module.rgb(theme.colour.red)
      })
    end
  end
end

---@return function toggleFloat A function that toggles the floting property of a window, respecting the masterTabbed layout.
module.toggleFloat = function()
  return function()
    if hl.get_active_special_workspace() ~= nil then
      hl.dispatch(hl.dsp.window.float({action = "toggle"}))
      return
    end

    local workspace = hl.get_active_workspace()
    if workspace ~= nil and workspace.groups == 0 then
      hl.dispatch(hl.dsp.window.float({action = "toggle"}))
    elseif workspace ~= nil then
      local activeWindow = workspace.last_window
      if activeWindow ~= nil and activeWindow.floating then
        local orientation = hl.get_config("master.orientation")
        hl.dispatch(hl.dsp.window.float({action = "toggle"}))
        hl.dispatch(hl.dsp.layout("swapwithmaster ignoremaster"))
        if orientation == "left" then
          hl.dispatch(hl.dsp.window.move({into_group = "r"}))
        elseif orientation == "top" then
          hl.dispatch(hl.dsp.window.move({into_group = "d"}))
        end
      else
        hl.dispatch(hl.dsp.window.move({out_of_group = true}))
        hl.dispatch(hl.dsp.window.float({action = "toggle"}))
      end
    else
      hl.notification.create({
        text = "Unreachable!:module.toggleFloat",
        duration = 3000,
        color = module.rgb(theme.colour.red)
      })
    end
  end
end

---@return function toggleFocusFloating A function that switches the focus from a floating window to tiled window
module.toggleFocusFloating = function()
  return function()
    local activeWindow = hl.get_active_window()
    if activeWindow == nil then return end
    if activeWindow.floating then
      hl.dispatch(hl.dsp.focus({window = "tiled"}))
    else
      hl.dispatch(hl.dsp.focus({window = "floating"}))
    end
  end
end

---@return function launcher A function that invokes the app launcher
module.launcher = function()
  return function()
    local currentSpecial = hl.get_active_special_workspace()
    local currentWorkspace = hl.get_active_workspace()
    local count = -1
    if currentSpecial ~= nil then
      count = currentSpecial.windows or 0
    elseif currentWorkspace ~= nil then
      count = currentWorkspace.windows or 0
    end
    if count == 0 then
      hl.dispatch(hl.dsp.exec_cmd(
                      "rofi -show drun -theme-str \"window { y-offset: -36px; }\""))
    else
      hl.dispatch(hl.dsp.exec_cmd("rofi -show drun"))
    end
  end
end

---@param rgb string rgb value of a colour (rrggbb)
---@return string colour The colour in hyprland rgb format
module.rgb = function(rgb)
  if rgb:sub(1, 1) == "#" then return "rgb(" .. rgb:sub(2) .. ")" end
  return "rgb(" .. rgb .. ")"
end

---@param rgb string rgb value of a colour (rrggbb)
---@param a string opacity value (aa)
---@return string colour The colour in hyprland rbga format
module.rgba = function(rgb, a)
  if rgb:sub(1, 1) == "#" then return "rgba(" .. rgb:sub(2) .. a .. ")" end
  return "rgba(" .. rgb .. a .. ")"
end

---@param themeName string
module.changeTheme = function(themeName)
  local newTheme = require("themes." .. themeName)
  hl.config({
    group = {
      col = {
        border_active = {
          colors = {
            module.rgba("0000FF", "AA"),
            -- module.rgba(newTheme.colour.blue, "AA"),
            module.rgba(newTheme.colour.magenta, "AA")
          }
        },
        border_inactive = module.rgba(newTheme.colour.background, "AA")
      },
      groupbar = {
        text_color = module.rgba(newTheme.colour.foreground, "FF"),
        col = {
          active = module.rgba(newTheme.colour.blue, "FF"),
          inactive = module.rgba(newTheme.colour.background, "FF")
        }
      }
    },
    general = {
      col = {
        active_border = {
          colors = {
            module.rgba(newTheme.colour.blue, "AA"),
            module.rgba(newTheme.colour.magenta, "AA")
          }
        },
        inactive_border = module.rgba(newTheme.colour.background, "AA")
      }
    }
  })
end

---@return string theme_name theme name (from themes/*.lua)
module.getActiveTheme = function()
  local configDir = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") ..
                        "/.config"
  local hyprDir = configDir .. "/hypr"
  local themeFile = io.open(hyprDir .. "/.theme")
  if themeFile ~= nil then return themeFile:read("*l") or "toykonightstorm" end
  return "tokyonightstorm" -- Default theme
end

---@param left boolean right or not
---@return function moveView move the view of scrolling layout
module.moveView = function(left)
  return function()
    local activeWorkspace = hl.get_active_workspace()
    local activeSpecial = hl.get_active_special_workspace()
    if activeSpecial ~= nil then return end
    if activeWorkspace ~= nil and activeWorkspace.tiled_layout == "scrolling" then
      if left then
        hl.dispatch(hl.dsp.layout("move -col"))
      else
        hl.dispatch(hl.dsp.layout("move +col"))
      end
    end
  end
end

return module

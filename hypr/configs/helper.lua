module = {}

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

---@param app { name: string, key: string, cmd: string }
---@return function namedSp A function that toggles the dropdown app of choice
module.namedSp = function(app)
  return function()
    local specialWs = hl.get_workspace("name:special:" .. app.name)
    if specialWs == nil then
      hl.exec_cmd(app.cmd, {
        workspace = "special:" .. app.name,
        focus_on_activate = true
      })
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
    color = "rgba(ff0000ff)"
  })
  return hl.dispatch(hl.dsp.no_op())
end

---@return function masterTabbedToggle A function to toggle between regular master layout and tabbed layout (see xmonad for comparison)
module.masterTabbedToggle = function()
  return function()
    if hl.get_active_special_workspace() ~= nil then return end
    local workspace = hl.get_active_workspace()
    if workspace == nil or workspace.windows == 0 then return end
    if workspace.groups == 0 then
      local activeWindow = workspace.last_window.address
      local orientation = hl.get_config("master.orientation")
      hl.dispatch(hl.dsp.layout("focusmaster master"))
      hl.dispatch(hl.dsp.window.tag({tag = "mmaster"}))
      hl.dispatch(hl.dsp.group.toggle())
      if workspace.windows > 1 then
        for _ = 2, workspace.windows do
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
      local activeWindow = workspace.last_window.address
      local windows = hl.get_windows({workspace = workspace})
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
            color = "rgba(ff0000ff)"
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
  end
end

---@param next boolean
---@return function cycleWindow A function then cycles the window focus respecting the masterTabbed layout and floating window
module.cycleWindow = function(next)
  return function()
    local direction
    if next then
      direction = "next"
    else
      direction = "prev"
    end
    local activeWindow = hl.get_active_window()
    if activeWindow == nil then return end
    if activeWindow.floating then
      hl.dispatch(hl.dsp.window.cycle_next({next = next, floating = true}))
    elseif activeWindow.group ~= nil then
      if next then
        hl.dispatch(hl.dsp.group.next())
      else
        hl.dispatch(hl.dsp.group.prev())
      end
    else
      hl.dispatch(hl.dsp.layout("cycle" .. direction))
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
        hl.dispatch(hl.dsp.layout("swapnext"))
      else
        hl.dispatch(hl.dsp.layout("swapprev"))
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
        color = "rgba(ff0000ff)"
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
        color = "rgba(ff0000ff)"
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

return module

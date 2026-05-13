module = {}

---@param direction string
---@param debug     boolean
---@return function
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
      if direction == "l" then
        hl.dispatch(hl.dsp.window.move({workspace = tostring(prev)}))
      elseif direction == "r" then
        hl.dispatch(hl.dsp.window.move({workspace = tostring(next)}))
      else
        hl.notification.create({text = "Unknown direction", duration = 5000})
        return hl.dsp.no_op()
      end
    else
      hl.notification.create({text = "Unknown workspace id", duration = 5000})
      return hl.dsp.no_op()
    end
  end
end

---@param app { name: string, key: string, cmd: string }
---@return function
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

---@return string
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

---@return string
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
---@return function | HL.Dispatcher
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
  return hl.dispatch(hl.dsp.no_op())
end

return module

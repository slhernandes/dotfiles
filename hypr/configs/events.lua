hl.on("window.active",
      function(_) hl.dispatch(hl.dsp.window.alter_zorder({mode = "top"})) end)

hl.on("window.open", function(w)
  local activeWindow = hl.get_active_window()
  if activeWindow == nil then
    hl.dispatch(hl.dsp.focus({window = "address:" .. w.address}))
  end
end)

hl.on("window.move_to_workspace", function(win, ws)
  if ws ~= nil and ws.name == "special:minimized" then
    hl.exec_cmd(string.format("sleep 0.3; grim -T %x /tmp/minimize/%s.png",
                              win.stable_id, win.address))
  end
end)

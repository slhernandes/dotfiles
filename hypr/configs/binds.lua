local helper = require("configs.helper")
local specialWs = require("configs.specialws")
-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/

hl.bind(MainMod .. "+ U", hl.dsp.exec_cmd("hyprlock"))
hl.bind(MainMod .. "+ SHIFT + U",
        hl.dsp.exec_cmd(ScriptDir .. "/utf_selector.sh"))
-- hl.bind(MainMod .. "+ SHIFT + U", helper.utfSelector()) -- Still broken
hl.bind(MainMod .. "+ T", hl.dsp.exec_cmd(Terminal))
hl.bind(MainMod .. "+ F", hl.dsp.exec_cmd(Browser))
hl.bind(MainMod .. "+ M", hl.dsp.exec_cmd(ScriptDir .. "/minimize.py minimize"))
-- hl.bind(MainMod .. "+ SHIFT + M",
--   hl.dsp.exec_cmd(ScriptDir .. "/minimize.py restorerofi"))
hl.bind(MainMod .. "+ SHIFT + M",
        hl.dsp.exec_cmd("qs ipc call globalStates toggleMinimize"))
hl.bind(MainMod .. "+ W", hl.dsp.exec_cmd(ScriptDir .. "/change_wallpaper.sh"))
hl.bind(MainMod .. "+ SHIFT + W",
        hl.dsp.exec_cmd(ScriptDir .. "/change_theme.sh"))
-- hl.bind(MainMod .. "+ P", helper.launcher())
hl.bind(MainMod .. "+ P",
        hl.dsp.exec_cmd("qs ipc call globalStates toggleLauncher center"))
hl.bind(MainMod .. "+ Return", helper.maximizeToggle())
hl.bind(MainMod .. "+ SHIFT + Return",
        hl.dsp.window.fullscreen({action = "toggle", mode = "fullscreen"}))
hl.bind(MainMod .. "+ C", hl.dsp.exec_cmd(ScriptDir .. "/passmenu"))
hl.bind(MainMod .. "+ SHIFT + C", hl.dsp.window.close({}))
hl.bind(MainMod .. "+ SHIFT + S", helper.toggleFloat())
hl.bind(MainMod .. "+ SHIFT + Q",
        hl.dsp.exec_cmd("qs ipc call globalStates toggleControlCentre"))
hl.bind(MainMod .. "+ N",
        hl.dsp.exec_cmd("qs ipc call globalStates toggleNotificationCentre"))
hl.bind(MainMod .. "+ SHIFT + P", hl.dsp.exec_cmd(ScriptDir .. "/find_pdf"))
hl.bind(MainMod .. "+ Space", hl.dsp.exec_cmd(ScriptDir .. "/rofisearch.sh"))
-- hl.bind(MainMod .. "+ N", hl.dsp.exec_cmd(, swaync-client -t -sw
hl.bind("SHIFT + F1", hl.dsp.exec_cmd(ScriptDir .. "/volume mute"),
        {repeating = true})
hl.bind("SHIFT + F2", hl.dsp.exec_cmd("playerctl previous"), {repeating = true})
hl.bind("SHIFT + F3", hl.dsp.exec_cmd("playerctl play-pause"),
        {repeating = true})
hl.bind("SHIFT + F4", hl.dsp.exec_cmd("playerctl next"), {repeating = true})
hl.bind("SHIFT + F5", helper.volume("out", "down"), {repeating = true})
hl.bind("SHIFT + F6", helper.volume("out", "up"), {repeating = true})
hl.bind("SHIFT + F7", hl.dsp
            .exec_cmd("lux -s 5% && qs ipc call brightnessOSD openOSD $(lux -G)"),
        {repeating = true})
hl.bind("SHIFT + F8", hl.dsp
            .exec_cmd("lux -a 5% && qs ipc call brightnessOSD openOSD $(lux -G)"),
        {repeating = true})
hl.bind("SHIFT + F9", hl.dsp.exec_cmd(ScriptDir .. "/lowpowermode toggle"),
        {repeating = true})
hl.bind(MainMod .. "+ S", hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --notify copysave area"))

-- Move focus with MainMod + arrow keys
hl.bind(MainMod .. "+ left", hl.dsp.focus({direction = "l"}), {repeating = true})
hl.bind(MainMod .. "+ right", hl.dsp.focus({direction = "r"}),
        {repeating = true})
hl.bind(MainMod .. "+ up", hl.dsp.focus({direction = "u"}), {repeating = true})
hl.bind(MainMod .. "+ down", hl.dsp.focus({direction = "d"}), {repeating = true})
hl.bind(MainMod .. "+ SHIFT + right", hl.dsp.window.move({direction = "r"}),
        {repeating = true})
hl.bind(MainMod .. "+ SHIFT + left", hl.dsp.window.move({direction = "l"}),
        {repeating = true})
hl.bind(MainMod .. "+ SHIFT + up", hl.dsp.window.move({direction = "u"}),
        {repeating = true})
hl.bind(MainMod .. "+ SHIFT + down", hl.dsp.window.move({direction = "d"}),
        {repeating = true})

hl.bind(MainMod .. "+ J", helper.cycleWindow(true), {repeating = true})
hl.bind(MainMod .. "+ K", helper.cycleWindow(false), {repeating = true})
hl.bind(MainMod .. "+ SHIFT + J", helper.swapWindow(true))
hl.bind(MainMod .. "+ SHIFT + K", helper.swapWindow(false))
hl.bind(MainMod .. "+ ALT + J", helper.moveView(true))
hl.bind(MainMod .. "+ ALT + K", helper.moveView(false))
hl.bind(MainMod .. "+ ALT + H", helper.moveView(true))
hl.bind(MainMod .. "+ ALT + L", helper.moveView(false))
hl.bind(MainMod .. "+ ALT + S", helper.toggleFocusFloating())

--------------------
-- Submap RESIZE
hl.bind(MainMod .. "+ R", hl.dsp.submap("RESIZE"))

hl.define_submap("RESIZE", function()
  local conf = {
    {key = {"right", "L"}, opt = {x = 10, y = 0, relative = true}},
    {key = {"left", "H"}, opt = {x = -10, y = 0, relative = true}},
    {key = {"up", "K"}, opt = {x = 0, y = -10, relative = true}},
    {key = {"down", "J"}, opt = {x = 0, y = 10, relative = true}}
  }
  for _, v in ipairs(conf) do
    for _, k in ipairs(v.key) do
      hl.bind(k, hl.dsp.window.move(v.opt), {repeating = true})
      hl.bind("SHIFT + " .. k, hl.dsp.window.resize(v.opt), {repeating = true})
    end
  end
  hl.bind("escape", hl.dsp.submap("reset"))
end)
--------------------

-- Switch workspaces with MainMod + [1-9] and move window to workspace with MainMod + SHIFT + [1-9]
for i = 1, 9 do
  local ws = tostring(i)
  hl.bind(MainMod .. "+" .. ws, hl.dsp.focus({workspace = ws}))
  hl.bind(MainMod .. "+ SHIFT +" .. ws, function()
    local activeWindow = hl.get_active_window()
    if activeWindow ~= nil and activeWindow.group ~= nil then
      hl.dispatch(hl.dsp.window.move({out_of_group = true}))
    end
    hl.dispatch(hl.dsp.window.move({workspace = ws, follow = false}))
  end)
end

hl.bind(MainMod .. "+ 0", function()
  local activeSpecialWs = hl.get_active_special_workspace()
  if activeSpecialWs ~= nil then
    local specialWsSuffix = string.match(activeSpecialWs.name, "[^:]+$") or
                                "magic"
    hl.dispatch(hl.dsp.workspace.toggle_special(specialWsSuffix))
  else
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  end
end)
hl.bind(MainMod .. "+ SHIFT + 0",
        hl.dsp.window.move({workspace = "special:magic"}))
hl.bind(MainMod .. "+ minus", hl.dsp.workspace.toggle_special("minimized"))
hl.bind(MainMod .. "+ H", hl.dsp.focus({workspace = "e-1"}), {repeating = true})
hl.bind(MainMod .. "+ L", hl.dsp.focus({workspace = "e+1"}), {repeating = true})
hl.bind(MainMod .. "+ comma", hl.dsp.layout("orientationcycle left top"))

hl.bind(MainMod .. "+ SHIFT + H", helper.moveWindow("l", false))
hl.bind(MainMod .. "+ SHIFT + L", helper.moveWindow("r", false))

-- Scroll through existing workspaces with MainMod + scroll
hl.bind(MainMod .. "+ mouse_down", hl.dsp.focus({workspace = "e+1"}))
hl.bind(MainMod .. "+ mouse_up", hl.dsp.focus({workspace = "e-1"}))

-- Move/resize windows with MainMod + LMB/RMB and dragging
hl.bind(MainMod .. "+ mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind(MainMod .. "+ mouse:273", hl.dsp.window.resize(), {mouse = true})
hl.bind("XF86AudioRaiseVolume", helper.volume("out", "up"),
        {repeating = true, locked = true})
hl.bind("XF86AudioLowerVolume", helper.volume("out", "down"),
        {repeating = true, locked = true})
hl.bind("XF86AudioMute", helper.volume("out", "mute"), {locked = true})
hl.bind("XF86AudioMicMute", helper.volume("in", "mute"), {locked = true})
hl.bind("SHIFT + XF86AudioRaiseVolume", helper.volume("in", "up"),
        {repeating = true, locked = true})
hl.bind("SHIFT + XF86AudioLowerVolume", helper.volume("in", "down"),
        {repeating = true, locked = true})
hl.bind("SHIFT + XF86AudioMute", helper.volume("in", "mute"), {locked = true})

hl.bind(MainMod .. "+ mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind(MainMod .. "+ mouse:273", hl.dsp.window.resize(), {mouse = true})
hl.bind("mouse:272", hl.dsp.exec_cmd("pkill rofi"), {non_consuming = true})
hl.bind("mouse:273", hl.dsp.exec_cmd("pkill rofi"), {non_consuming = true})

-- trigger when the switch is toggled
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"),
        {locked = true})
-- trigger when the switch is turning on
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"),
        {locked = true})
-- trigger when the switch is turning off
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"),
        {locked = true})

--------------------
-- Submap DROPDOWN
hl.bind(MainMod .. "+ D", hl.dsp.submap("DROPDOWN"))
hl.define_submap("DROPDOWN", "reset", function()
  for _, v in ipairs(specialWs.suffixes) do
    if v.key ~= nil and v.cmd ~= nil then hl.bind(v.key, helper.namedSp(v)) end
  end
  hl.bind("catchall", hl.dsp.submap("reset"))
end)
--------------------
-------------------
-- Submap passthrough
hl.bind(MainMod .. "+ F10", hl.dsp.submap("PASSTHROUGH"))
hl.define_submap("PASSTHROUGH", function()
  hl.bind(MainMod .. "+ escape", hl.dsp.submap("reset"))
end)

-- Global Shortcuts
hl.bind(MainMod .. "+ ALT + M", hl.dsp.send_shortcut({
  mods = "CTRL SHIFT",
  key = "M",
  window = "class:^(vesktop)"
}))
hl.bind(MainMod .. "+ ALT + D", hl.dsp.send_shortcut({
  mods = "CTRL SHIFT",
  key = "D",
  window = "class:^(vesktop)"
}))

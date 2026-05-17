local helper = require("configs.helper")
local terminal = "ghostty -e " .. os.getenv("HOME") ..
    "/.config/tmux/bin/tmux-start"
-- local fileManager = "ghostty -e yazi"
local browser = "firefox -P default-release --setDefaultBrowser"
local hyprDir = os.getenv("XDG_CONFIG_HOME") .. "/hypr"
local scriptDir = hyprDir .. "/scripts"
local menu = scriptDir .. "/drun.sh"
local mainMod = "SUPER "

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/

hl.bind(mainMod .. "+ U", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. "+ SHIFT + U",
  hl.dsp.exec_cmd(scriptDir .. "/utf_selector.sh"))
hl.bind(mainMod .. "+ T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+ F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. "+ M", hl.dsp.exec_cmd(scriptDir .. "/minimize.py minimize"))
hl.bind(mainMod .. "+ SHIFT + M",
  hl.dsp.exec_cmd(scriptDir .. "/minimize.py restorerofi"))
hl.bind(mainMod .. "+ W", hl.dsp.exec_cmd(scriptDir .. "/change_wallpaper.sh"))
hl.bind(mainMod .. "+ SHIFT + W",
  hl.dsp.exec_cmd(scriptDir .. "/change_theme.sh"))
hl.bind(mainMod .. "+ P", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. "+ Return", helper.masterTabbedToggle())
hl.bind(mainMod .. "+ SHIFT + Return",
  hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mainMod .. "+ C", hl.dsp.exec_cmd(scriptDir .. "/passmenu"))
hl.bind(mainMod .. "+ SHIFT + C", hl.dsp.window.close({}))
hl.bind(mainMod .. "+ SHIFT + S", helper.toggleFloat())
hl.bind(mainMod .. "+ SHIFT + Q",
  hl.dsp.exec_cmd("qs ipc call globalStates toggleControlCentre"))
hl.bind(mainMod .. "+ SHIFT + P", hl.dsp.exec_cmd(scriptDir .. "/find_pdf"))
hl.bind(mainMod .. "+ Space", hl.dsp.exec_cmd(scriptDir .. "/rofisearch.sh"))
-- hl.bind(mainMod .. "+ N", hl.dsp.exec_cmd(, swaync-client -t -sw
hl.bind("SHIFT + F1", hl.dsp.exec_cmd(scriptDir .. "/volume mute"),
  { repeating = true })
hl.bind("SHIFT + F2", hl.dsp.exec_cmd("playerctl previous"), { repeating = true })
hl.bind("SHIFT + F3", hl.dsp.exec_cmd("playerctl play-pause"),
  { repeating = true })
hl.bind("SHIFT + F4", hl.dsp.exec_cmd("playerctl next"), { repeating = true })
hl.bind("SHIFT + F5", helper.volume("out", "down"), { repeating = true })
hl.bind("SHIFT + F6", helper.volume("out", "up"), { repeating = true })
hl.bind("SHIFT + F7", hl.dsp
  .exec_cmd("lux -s 5% && qs ipc call brightnessOSD openOSD $(lux -G)"),
  { repeating = true })
hl.bind("SHIFT + F8", hl.dsp
  .exec_cmd("lux -a 5% && qs ipc call brightnessOSD openOSD $(lux -G)"),
  { repeating = true })
hl.bind("SHIFT + F9", hl.dsp.exec_cmd(scriptDir .. "/lowpowermode toggle"),
  { repeating = true })
hl.bind(mainMod .. "+ S", hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --notify copysave area"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. "+ left", hl.dsp.focus({ direction = "l" }), { repeating = true })
hl.bind(mainMod .. "+ right", hl.dsp.focus({ direction = "r" }),
  { repeating = true })
hl.bind(mainMod .. "+ up", hl.dsp.focus({ direction = "u" }), { repeating = true })
hl.bind(mainMod .. "+ down", hl.dsp.focus({ direction = "d" }), { repeating = true })
hl.bind(mainMod .. "+ SHIFT + right", hl.dsp.window.move({ direction = "r" }),
  { repeating = true })
hl.bind(mainMod .. "+ SHIFT + left", hl.dsp.window.move({ direction = "l" }),
  { repeating = true })
hl.bind(mainMod .. "+ SHIFT + up", hl.dsp.window.move({ direction = "u" }),
  { repeating = true })
hl.bind(mainMod .. "+ SHIFT + down", hl.dsp.window.move({ direction = "d" }),
  { repeating = true })

hl.bind(mainMod .. "+ J", helper.cycleWindow(false), { repeating = true })
hl.bind(mainMod .. "+ K", helper.cycleWindow(true), { repeating = true })
hl.bind(mainMod .. "+ SHIFT + J", helper.swapWindow(true))
hl.bind(mainMod .. "+ SHIFT + K", helper.swapWindow(false))
hl.bind(mainMod .. "+ ALT + S", helper.toggleFocusFloating())

--------------------
-- Submap RESIZE
hl.bind(mainMod .. "+ R", hl.dsp.submap("RESIZE"))

hl.define_submap("RESIZE", function()
  hl.bind("right", hl.dsp.window.move({ x = 10, y = 0, relative = true }),
    { repeating = true })
  hl.bind("left", hl.dsp.window.move({ x = -10, y = 0, relative = true }),
    { repeating = true })
  hl.bind("up", hl.dsp.window.move({ x = 0, y = -10, relative = true }),
    { repeating = true })
  hl.bind("down", hl.dsp.window.move({ x = 0, y = 10, relative = true }),
    { repeating = true })
  hl.bind("L", hl.dsp.window.move({ x = 10, y = 0, relative = true }),
    { repeating = true })
  hl.bind("H", hl.dsp.window.move({ x = -10, y = 0, relative = true }),
    { repeating = true })
  hl.bind("K", hl.dsp.window.move({ x = 0, y = -10, relative = true }),
    { repeating = true })
  hl.bind("J", hl.dsp.window.move({ x = 0, y = 10, relative = true }),
    { repeating = true })
  hl.bind("SHIFT + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }),
    { repeating = true })
  hl.bind("SHIFT + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }),
    { repeating = true })
  hl.bind("SHIFT + K", hl.dsp.window.resize({ x = 0, y = 10, relative = true }),
    { repeating = true })
  hl.bind("SHIFT + J", hl.dsp.window.resize({ x = 0, y = -10, relative = true }),
    { repeating = true })
  hl.bind("escape", hl.dsp.submap("reset"))
end)
--------------------

-- Switch workspaces with mainMod + [1-9] and move window to workspace with mainMod + SHIFT + [1-9]
for i = 1, 9 do
  local ws = tostring(i)
  hl.bind(mainMod .. "+" .. ws, hl.dsp.focus({ workspace = ws }))
  hl.bind(mainMod .. "+ SHIFT +" .. ws, function()
    local activeWindow = hl.get_active_window()
    if activeWindow ~= nil and activeWindow.group ~= nil then
      hl.dispatch(hl.dsp.window.move({ out_of_group = true }))
    end
    hl.dispatch(hl.dsp.window.move({ workspace = ws, follow = false }))
  end)
end

hl.bind(mainMod .. "+ 0", function()
  local specialWs = hl.get_active_special_workspace()
  if specialWs ~= nil then
    local specialWsSuffix = string.match(specialWs.name, "[^:]+$") or "magic"
    hl.dispatch(hl.dsp.workspace.toggle_special(specialWsSuffix))
  else
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
  end
end)
hl.bind(mainMod .. "+ SHIFT + 0",
  hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. "+ minus", hl.dsp.workspace.toggle_special("minimized"))
hl.bind(mainMod .. "+ H", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind(mainMod .. "+ L", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind(mainMod .. "+ comma", hl.dsp.layout("orientationcycle left top"))

hl.bind(mainMod .. "+ SHIFT + H", helper.moveWindow("l", false))
hl.bind(mainMod .. "+ SHIFT + L", helper.moveWindow("r", false))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. "+ mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. "+ mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("XF86AudioRaiseVolume", helper.volume("out", "up"),
  { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", helper.volume("out", "down"),
  { repeating = true, locked = true })
hl.bind("XF86AudioMute", helper.volume("out", "mute"), { locked = true })
hl.bind("XF86AudioMicMute", helper.volume("in", "mute"), { locked = true })
hl.bind("SHIFT + XF86AudioRaiseVolume", helper.volume("in", "up"),
  { repeating = true, locked = true })
hl.bind("SHIFT + XF86AudioLowerVolume", helper.volume("in", "down"),
  { repeating = true, locked = true })
hl.bind("SHIFT + XF86AudioMute", helper.volume("in", "mute"), { locked = true })

hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("mouse:272", hl.dsp.exec_cmd("pkill rofi"),
  { click = true, non_consuming = true })
hl.bind("mouse:273", hl.dsp.exec_cmd("pkill rofi"),
  { click = true, non_consuming = true })

-- trigger when the switch is toggled
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"),
  { locked = true })
-- trigger when the switch is turning on
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"),
  { locked = true })
-- trigger when the switch is turning off
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"),
  { locked = true })

local shaderPath = os.getenv("HOME") .. "/.config/ghostty/shaders/retro.glsl"
local specialWsSuffixes = {
  { name = "magic",   key = nil, cmd = nil }, {
  name = "btop",
  key = "B",
  cmd = "ghostty --custom-shader=" .. shaderPath .. " -e btop"
},
  { name = "firefox", key = "F", cmd = "firefox --name=firefox_sp -P scratchpad" },
  { name = "wezterm", key = "T", cmd = "wezterm start --class=wezterm_sp" }, {
  name = "yazi",
  key = "R",
  cmd = "ghostty --custom-shader=" .. shaderPath .. " -e yazi"
}, { name = "ferdium", key = "Y", cmd = "ferdium" }, {
  name = "ncmpcpp",
  key = "N",
  cmd = "ghostty --custom-shader=" .. shaderPath .. " -e ncmpcpp"
}
}

for _, v in ipairs(specialWsSuffixes) do
  hl.workspace_rule({
    workspace = "name:special:" .. v.name,
    gaps_out = { top = 4, left = 320, right = 335, bottom = 341 }
  })
end

--------------------
-- Submap DROPDOWN
hl.bind(mainMod .. "+ D", hl.dsp.submap("DROPDOWN"))
hl.define_submap("DROPDOWN", "reset", function()
  for _, v in ipairs(specialWsSuffixes) do
    if v.key ~= nil and v.cmd ~= nil then hl.bind(v.key, helper.namedSp(v)) end
  end
  hl.bind("catchall", hl.dsp.submap("reset"))
end)
--------------------

-- Global Shortcuts
hl.bind(mainMod .. "+ ALT + M", hl.dsp.send_shortcut({
  mods = "CTRL SHIFT",
  key = "M",
  window = "class:^(vesktop)"
}))
hl.bind(mainMod .. "+ ALT + D", hl.dsp.send_shortcut({
  mods = "CTRL SHIFT",
  key = "D",
  window = "class:^(vesktop)"
}))

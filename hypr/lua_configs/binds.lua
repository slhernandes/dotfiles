local terminal = "ghostty -e " .. os.getenv("HOME") .. "/.config/tmux/bin/tmux-start"
-- local fileManager = "ghostty -e yazi"
local browser = "firefox -P default-release --setDefaultBrowser"
local hyprDir = os.getenv("XDG_CONFIG_HOME") .. "/hypr"
local scriptDir = hyprDir .. "/scripts"
local menu = scriptDir .. "/drun.sh"
local mainMod = "SUPER "

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/

hl.bind(mainMod .. "+ U", hl.dsp.exec_cmd("hyprlock"))
-- hl.bind(mainMod .. "+ SHIFT + U", hl.dsp.exec_cmd(, rofimoji -f nerd_font emoji
hl.bind(mainMod .. "+ SHIFT + U", hl.dsp.exec_cmd(scriptDir .. "/utf_selector.sh"))
hl.bind(mainMod .. "+ T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+ F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. "+ M", hl.dsp.exec_cmd(scriptDir .. "/minimize.py minimize"))
hl.bind(mainMod .. "+ SHIFT + M", hl.dsp.exec_cmd(scriptDir .. "/minimize.py restorerofi"))
-- hl.bind(mainMod .. "+ R", hl.dsp.exec_cmd(, scriptDir/restart_waybar
hl.bind(mainMod .. "+ R", hl.dsp.exec_cmd(scriptDir .. "/restart_qs.sh"))
hl.bind(mainMod .. "+ W", hl.dsp.exec_cmd(scriptDir .. "/change_wallpaper.sh"))
hl.bind(mainMod .. "+ SHIFT + W", hl.dsp.exec_cmd(scriptDir .. "/change_theme.sh"))
hl.bind(mainMod .. "+ P", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. "+ Return", hl.dsp.window.fullscreen({action = "toggle", mode = "maximized"}))
hl.bind(mainMod .. "+ Return", function ()
  local layout = hl.get_config("general.layout")
  if layout == "monocle" then
    hl.config({general = {layout = "master"}})
  else
    hl.config({general = {layout = "monocle"}})
  end
end)
hl.bind(mainMod .. "+ SHIFT + Return", hl.dsp.window.fullscreen({action = "toggle", mode = "fullscreen"}))
hl.bind(mainMod .. "+ C", hl.dsp.exec_cmd(scriptDir .. "/passmenu"))
hl.bind(mainMod .. "+ SHIFT + C", hl.dsp.window.close({}))
hl.bind(mainMod .. "+ SHIFT + S", hl.dsp.window.float({action = "toggle"}))
hl.bind(mainMod .. "+ SHIFT + Q", hl.dsp.exec_cmd("qs ipc call globalStates toggleControlCentre"))
hl.bind(mainMod .. "+ SHIFT + P", hl.dsp.exec_cmd(scriptDir .. "/find_pdf"))
hl.bind(mainMod .. "+ Space", hl.dsp.exec_cmd(scriptDir .. "/rofisearch.sh"))
-- hl.bind(mainMod .. "+ N", hl.dsp.exec_cmd(, swaync-client -t -sw
hl.bind("SHIFT + F1", hl.dsp.exec_cmd(scriptDir .. "/volume mute"), {repeating = true})
hl.bind("SHIFT + F2", hl.dsp.exec_cmd("playerctl previous"), {repeating = true})
hl.bind("SHIFT + F3", hl.dsp.exec_cmd("playerctl play-pause"), {repeating = true})
hl.bind("SHIFT + F4", hl.dsp.exec_cmd("playerctl next"), {repeating = true})
hl.bind("SHIFT + F5", hl.dsp.exec_cmd(scriptDir .. "/volume down"), {repeating = true})
hl.bind("SHIFT + F6", hl.dsp.exec_cmd(scriptDir .. "/volume up"), {repeating = true})
hl.bind("SHIFT + F7", hl.dsp.exec_cmd(scriptDir .. "/brightness.sh down"), {repeating = true})
hl.bind("SHIFT + F8", hl.dsp.exec_cmd(scriptDir .. "/brightness.sh up"), {repeating = true})
hl.bind("SHIFT + F9", hl.dsp.exec_cmd(scriptDir .. "/lowpowermode toggle"), {repeating = true})
hl.bind(mainMod .. "+ S", hl.dsp.exec_cmd("grimblast --notify copysave area"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast --notify copysave area"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. "+ left", hl.dsp.focus({direction = "l"}), {repeating = true})
hl.bind(mainMod .. "+ right", hl.dsp.focus({direction = "r"}), {repeating = true})
hl.bind(mainMod .. "+ up", hl.dsp.focus({direction = "u"}), {repeating = true})
hl.bind(mainMod .. "+ down", hl.dsp.focus({direction = "d"}), {repeating = true})
hl.bind(mainMod .. "+ SHIFT + right", hl.dsp.window.move({direction = "r"}), {repeating = true})
hl.bind(mainMod .. "+ SHIFT + left", hl.dsp.window.move({direction = "l"}), {repeating = true})
hl.bind(mainMod .. "+ SHIFT + up", hl.dsp.window.move({direction = "u"}), {repeating = true})
hl.bind(mainMod .. "+ SHIFT + down", hl.dsp.window.move({direction = "d"}), {repeating = true})
hl.bind(mainMod .. "+ K", hl.dsp.layout("cycleprev"), {repeating = true})
hl.bind(mainMod .. "+ J", hl.dsp.layout("cyclenext"), {repeating = true})
hl.bind(mainMod .. "+ SHIFT + K", function ()
  if hl.get_config("general.layout") == "master" then
    hl.dispatch(hl.dsp.layout("rollnext"))
  else
    hl.dispatch(hl.dsp.no_op())
  end
end, {repeating = true})
hl.bind(mainMod .. "+ SHIFT + J", function ()
  if hl.get_config("general.layout") == "master" then
    hl.dispatch(hl.dsp.layout("rollprev"))
  else
    hl.dispatch(hl.dsp.no_op())
  end
end, {repeating = true})

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. "+ 1", hl.dsp.focus({workspace = "1"}))
hl.bind(mainMod .. "+ 2", hl.dsp.focus({workspace = "2"}))
hl.bind(mainMod .. "+ 3", hl.dsp.focus({workspace = "3"}))
hl.bind(mainMod .. "+ 4", hl.dsp.focus({workspace = "4"}))
hl.bind(mainMod .. "+ 5", hl.dsp.focus({workspace = "5"}))
hl.bind(mainMod .. "+ 6", hl.dsp.focus({workspace = "6"}))
hl.bind(mainMod .. "+ 7", hl.dsp.focus({workspace = "7"}))
hl.bind(mainMod .. "+ 8", hl.dsp.focus({workspace = "8"}))
hl.bind(mainMod .. "+ 9", hl.dsp.focus({workspace = "9"}))
hl.bind(mainMod .. "+ 0", hl.dsp.exec_cmd(scriptDir .. "/togglespecial.sh"))
hl.bind(mainMod .. "+ minus", hl.dsp.workspace.toggle_special("minimized"))
hl.bind(mainMod .. "+ h", hl.dsp.focus({workspace = "e-1"}), {repeating = true})
hl.bind(mainMod .. "+ l", hl.dsp.focus({workspace = "e+1"}), {repeating = true})
hl.bind(mainMod .. "+ comma", hl.dsp.layout("orientationcycle left top"))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. "+ SHIFT + 1", hl.dsp.window.move({workspace = "1", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 2", hl.dsp.window.move({workspace = "2", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 3", hl.dsp.window.move({workspace = "3", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 4", hl.dsp.window.move({workspace = "4", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 5", hl.dsp.window.move({workspace = "5", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 6", hl.dsp.window.move({workspace = "6", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 7", hl.dsp.window.move({workspace = "7", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 8", hl.dsp.window.move({workspace = "8", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 9", hl.dsp.window.move({workspace = "9", follow = false}))
hl.bind(mainMod .. "+ SHIFT + 0", hl.dsp.window.move({workspace = "special:magic"}))

hl.bind(mainMod .. "+ SHIFT + h", function ()
  local ws = hl.get_active_workspace()
  local now = tonumber(ws.name)
  if now ~= nil then
    local prev = (now - 2) % 9 + 1
    hl.dispatch(hl.dsp.window.move({workspace = tostring(prev)}))
  else
    hl.notification.create({text = "Not supported on workspace " .. ws.name, duration = 5000})
    hl.dispatch(hl.dsp.no_op())
  end
end, {repeating = true})
hl.bind(mainMod .. "+ SHIFT + l", function ()
  local ws = hl.get_active_workspace()
  local now = tonumber(ws.name)
  if now ~= nil then
    local next = (now % 9) + 1
    hl.dispatch(hl.dsp.window.move({workspace = tostring(next)}))
  else
    hl.notification.create({text = "Not supported on workspace " .. ws.name, duration = 5000})
    hl.dispatch(hl.dsp.no_op())
  end
end, {repeating = true})

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. "+ mouse_down", hl.dsp.focus({workspace = "e+1"}))
hl.bind(mainMod .. "+ mouse_up", hl.dsp.focus({workspace = "e-1"}))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptDir .. "/volume up"), {repeating = true, locked = true})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptDir .. "/volume down"), {repeating = true, locked = true})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptDir .. "/volume mute"), {locked = true})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptDir .. "/volume_input mute"), {locked = true})
hl.bind("SHIFT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptDir .. "/volume_input up"), {repeating = true, locked = true})
hl.bind("SHIFT + XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptDir .. "/volume_input down"), {repeating = true, locked = true})
hl.bind("SHIFT + XF86AudioMute", hl.dsp.exec_cmd(scriptDir .. "/volume_input mute"), {locked = true})

hl.bind(mainMod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("mouse:272", hl.dsp.exec_cmd("pkill rofi"), {click = true, non_consuming = true})
hl.bind("mouse:273", hl.dsp.exec_cmd("pkill rofi"), {click = true, non_consuming = true})

-- trigger when the switch is toggled
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), {locked = true})
-- trigger when the switch is turning on
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms off"), {locked = true})
-- trigger when the switch is turning off
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), {locked = true})

-- hl.workspace_rule({workspace = "name:^(special:.*)$", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})
hl.workspace_rule({workspace = "name:special:magic", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})

-- Special Workspaces
hl.bind(mainMod .. "+ SHIFT + B", hl.dsp.exec_cmd(scriptDir .. "/namedsp.sh btop"))
hl.workspace_rule({workspace = "name:special:btop", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})

hl.bind(mainMod .. "+ SHIFT + F", hl.dsp.exec_cmd(scriptDir .. "/namedsp.sh firefox"))
hl.workspace_rule({workspace = "name:special:firefox", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})

-- hl.bind(mainMod .. "+ SHIFT + T", hl.dsp.exec_cmd(, scriptDir/namedsp.sh ghostty
-- workspace = name:special:ghostty, gapsout:4 320 335 341

hl.bind(mainMod .. "+ SHIFT + T", hl.dsp.exec_cmd(scriptDir .. "/namedsp.sh wezterm"))
hl.workspace_rule({workspace = "name:special:wezterm", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})

hl.bind(mainMod .. "+ SHIFT + R", hl.dsp.exec_cmd(scriptDir .. "/namedsp.sh yazi"))
hl.workspace_rule({workspace = "name:special:yazi", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})

hl.bind(mainMod .. "+ SHIFT + Y", hl.dsp.exec_cmd(scriptDir .. "/namedsp.sh ferdium"))
hl.workspace_rule({workspace = "name:special:ferdium", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})

hl.bind(mainMod .. "+ SHIFT + N", hl.dsp.exec_cmd(scriptDir .. "/namedsp.sh ncmpcpp"))
hl.workspace_rule({workspace = "name:special:ncmpcpp", gaps_out = {top = 4, left = 320, right = 335, bottom = 341}})
-- workspace = name:special:ncmpcpp, gapsout:4 320 335 341
-- Global Shortcuts
--
-- Example: 
-- hl.bind(SUPER, F10, sendshortcut, SUPER, F4, class:^(com\.obsproject\.Studio)  # Send SUPER + F4 to OBS when SUPER + F10 is pressed.
-- hl.bind(SUPER, F4, pass, class:^(com\.obsproject\.Studio)  # Send SUPER + F4 to OBS
--
hl.bind(mainMod .. "+ ALT + M", hl.dsp.send_shortcut({mods = "CTRL SHIFT", key = "M", window = "class:^(vesktop)"}))
hl.bind(mainMod .. "+ ALT + D", hl.dsp.send_shortcut({mods = "CTRL SHIFT", key = "D", window = "class:^(vesktop)"}))

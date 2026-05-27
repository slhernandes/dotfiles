local specialWs = require("configs.specialws")
hl.window_rule({match = {class = "^(kitty)$"}, opacity = "0.95 0.8"})

hl.window_rule({
  match = {class = "^(com.mitchellh.ghostty)$"},
  opacity = "0.95 0.8"
})

hl.window_rule({
  match = {class = "^(firefox)$"},
  opacity = "1.0 0.97",
  workspace = "5"
})

hl.window_rule({
  match = {class = "^(floorp)$"},
  opacity = "1.0 0.97",
  workspace = "5"
})

hl.window_rule({match = {class = "^(steam)$"}, workspace = "7 silent"})
hl.window_rule({match = {title = "^(Friends List)$"}, float = true})

hl.window_rule({match = {class = "^(steam_app_.*)$"}, fullscreen = true})

hl.window_rule({match = {class = "^(dota2)$"}, fullscreen = true})

hl.window_rule({
  match = {class = "^(steam_app_3513350)$", title = "^(\\s*)$"},
  float = true
})

hl.window_rule({match = {class = "^(wonderlands.exe)$"}, fullscreen = true})

hl.window_rule({match = {class = "^(steam_app_.*)$"}, workspace = "8"})

hl.window_rule({match = {class = "^(wonderlands.exe)$"}, workspace = "8"})

hl.window_rule({match = {class = "^(dota2)$"}, workspace = "8"})

hl.window_rule({match = {class = "^(Slay the Spire)$"}, workspace = "8"})

hl.window_rule({
  match = {class = "^(steam_app_.*)$"},
  immediate = true,
  workspace = "8"
})

hl.window_rule({match = {class = "^(cs2)$"}, immediate = true, workspace = "8"})

hl.window_rule({match = {class = "^(vesktop)$"}, workspace = "9"})

hl.window_rule({
  match = {initial_title = "^(Discord Popout)$"},
  float = true,
  pin = true,
  size = {"0.4*monitor_w", "0.4*monitor_h"},
  move = {"0.6*monitor_w-5", "0.6*monitor_h-5"}
})

hl.window_rule({match = {class = "^(hyprland-share-picker)$"}, float = true})

hl.window_rule({
  match = {title = "^(Picture-in-Picture)$"},
  float = true,
  pin = true,
  -- size = "<35% <35%",
  move = {"monitor_w-window_w-5", "monitor_h-window_h-5"}
})

hl.window_rule({
  match = {title = "^(Bild-im-Bild)$"},
  float = true,
  pin = true,
  -- size = "<35% <35%",
  move = {"monitor_w-window_w-5", "monitor_h-window_h-5"}
})

hl.window_rule({
  match = {title = "^(Waylyrics)$"},
  float = true,
  pin = true,
  size = "500 120",
  move = {"monitor_w-window_w-5", "monitor_h-window_h-5"}
})

hl.window_rule({match = {class = "^(dragon-drop)$"}, pin = true})

hl.window_rule({match = {class = "^(Rofi)$"}, stay_focused = true})

hl.window_rule({match = {class = ".*"}, suppress_event = "maximize"})

for _, v in ipairs(specialWs.suffixes) do
  hl.workspace_rule({
    workspace = "name:special:" .. v.name,
    gaps_out = {top = 4, left = 320, right = 335, bottom = 341}
  })
end

hl.layer_rule({
  match = {namespace = "swaync-.*"},
  blur = true,
  blur_popups = true,
  ignore_alpha = 0
})

hl.layer_rule({match = {namespace = "selection"}, no_anim = true})

hl.layer_rule({
  match = {namespace = "waybar"},
  blur = true,
  xray = true,
  ignore_alpha = 0.5
})

hl.layer_rule({
  match = {namespace = "qsBar"},
  blur = true,
  xray = true,
  ignore_alpha = 0.5
})

hl.layer_rule({
  match = {namespace = "qsControlCentre"},
  blur = true,
  -- xray = true,
  ignore_alpha = 0.5
})

hl.layer_rule({
  match = {namespace = "rofi"},
  blur = true,
  blur_popups = true,
  xray = true,
  ignore_alpha = 0.5
})

hl.layer_rule({
  match = {namespace = "notifications"},
  blur = true,
  blur_popups = true,
  xray = false,
  ignore_alpha = 0.5
})

hl.layer_rule({match = {namespace = "quickshell"}, order = 1})

hl.on("window.active",
      function(_) hl.dispatch(hl.dsp.window.alter_zorder({mode = "top"})) end)

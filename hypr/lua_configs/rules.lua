hl.window_rule({
  match = {
    class = "^(kitty)$",
  },
  opacity = "0.95 0.8",
})

hl.window_rule({
  match = {
    class = "^(com.mitchellh.ghostty)$",
  },
  opacity = "0.95 0.8",
})

hl.window_rule({
  match = {
    class = "^(firefox)$",
  },
  opacity = "1.0 0.97",
  workspace = "5",
})

hl.window_rule({
  match = {
    class = "^(floorp)$",
  },
  opacity = "1.0 0.97",
  workspace = "5",
})

hl.window_rule({
  match = {
    class = "^(steam)$",
  },
  workspace = "7 silent",
})

hl.window_rule({
  match = {
    title = "^(Friends List)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^(steam_app_.*)$",
  },
  fullscreen = true,
})

hl.window_rule({
  match = {
    class = "^(dota2)$",
  },
  fullscreen = true,
})

hl.window_rule({
  match = {
    class = "^(steam_app_3513350)$",
    title = "^(\\s*)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    class = "^(wonderlands.exe)$",
  },
  fullscreen = true,
})

hl.window_rule({
  match = {
    class = "^(steam_app_.*)$",
  },
  workspace = "8",
})

hl.window_rule({
  match = {
    class = "^(wonderlands.exe)$",
  },
  workspace = "8",
})

hl.window_rule({
  match = {
    class = "^(dota2)$",
  },
  workspace = "8",
})

hl.window_rule({
  match = {
    class = "^(Slay the Spire)$",
  },
  workspace = "8",
})

hl.window_rule({
  match = {
    class = "^(steam_app_.*)$",
  },
  immediate = true,
  workspace = "8",
})

hl.window_rule({
  match = {
    class = "^(cs2)$",
  },
  immediate = true,
  workspace = "8",
})

hl.window_rule({
  match = {
    class = "^(vesktop)$",
  },
  workspace = "9",
})

hl.window_rule({
  match = {
    initial_title = "^(Discord Popout)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    initial_title = "^(Discord Popout)$",
  },
  pin = true,
})

hl.window_rule({
  match = {
    initial_title = "^(Discord Popout)$",
  },
  size = "<40% <40%",
})

hl.window_rule({
  match = {
    initial_title = "^(Discord Popout)$",
  },
  move = "onscreen 100%-w-5 100%-w-5",
})

hl.window_rule({
  match = {
    class = "^(hyprland-share-picker)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    title = "^(Picture-in-Picture)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    title = "^(Picture-in-Picture)$",
  },
  pin = true,
})

hl.window_rule({
  match = {
    title = "^(Picture-in-Picture)$",
  },
  size = "<35% <35%",
})

hl.window_rule({
  match = {
    title = "^(Picture-in-Picture)$",
  },
  move = "onscreen 100%-w-5 100%-w-5",
})

hl.window_rule({
  match = {
    title = "^(Bild-im-Bild)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    title = "^(Bild-im-Bild)$",
  },
  pin = true,
})

hl.window_rule({
  match = {
    title = "^(Bild-im-Bild)$",
  },
  size = "<35% <35%",
})

hl.window_rule({
  match = {
    title = "^(Bild-im-Bild)$",
  },
  move = "onscreen 100%-w-5 100%-w-5",
})

hl.window_rule({
  match = {
    title = "^(Waylyrics)$",
  },
  float = true,
})

hl.window_rule({
  match = {
    title = "^(Waylyrics)$",
  },
  pin = true,
})

hl.window_rule({
  match = {
    title = "^(Waylyrics)$",
  },
  size = "500 120",
})

hl.window_rule({
  match = {
    title = "^(Waylyrics)$",
  },
  move = "onscreen 100%-w-5 100%-w-5",
})

hl.window_rule({
  match = {
    class = "^(dragon-drop)$",
  },
  pin = true,
})

hl.window_rule({
  match = {
    class = "^(Rofi)$",
  },
  stay_focused = true,
})

hl.window_rule({
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})

hl.layer_rule({
  match = {
    namespace = "swaync-.*",
  },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0,
})

hl.layer_rule({
  match = {
    namespace = "selection",
  },
  no_anim = true,
})

hl.layer_rule({
  match = {
    namespace = "waybar",
  },
  blur = true,
  xray = true,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = {
    namespace = "qsBar",
  },
  blur = true,
  xray = true,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = {
    namespace = "qsControlCentre",
  },
  blur = true,
  -- xray = true,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = {
    namespace = "rofi",
  },
  blur = true,
  blur_popups = true,
  xray = true,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = {
    namespace = "notifications",
  },
  blur = true,
  blur_popups = true,
  xray = false,
  ignore_alpha = 0.5,
})

hl.layer_rule({
  match = {
    namespace = "quickshell",
  },
  order = 1,
})

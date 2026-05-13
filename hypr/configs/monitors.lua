-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@120",
  position = "0x0",
  scale = "1",
})

hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "1",
  mirror = "eDP-1",
})

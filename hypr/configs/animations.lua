hl.curve("overshoot", { type = "bezier", points = { { 0.5, 0.9 }, { 0.1, 1.05 } } })
hl.curve("rubber",
  { type = "spring", mass = 1, stiffness = 878.5, dampening = 45 })
hl.animation({
  leaf = "windows",
  enabled = true,
  speed = 3,
  bezier = "overshoot",
  style = "gnomed"
})

hl.animation({
  leaf = "windowsOut",
  enabled = true,
  speed = 3,
  bezier = "default",
  style = "popin 80%"
})

hl.animation({
  leaf = "layers",
  enabled = true,
  speed = 3,
  bezier = "overshoot",
  style = "slide"
})

hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })

hl.animation({
  leaf = "borderangle",
  enabled = true,
  speed = 8,
  bezier = "default"
})

hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default" })

hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 3,
  bezier = "overshoot"
})

hl.animation({
  leaf = "specialWorkspace",
  enabled = true,
  speed = 3,
  spring = "rubber",
  style = "slidefadevert"
})

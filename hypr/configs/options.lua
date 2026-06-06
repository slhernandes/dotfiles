local helper = require("configs.helper")
local theme = require("themes." .. helper.getActiveTheme())
hl.config({cursor = {no_hardware_cursors = 2, no_warps = false}})

hl.config({
  input = {
    kb_layout = "de",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,
    natural_scroll = true,
    repeat_rate = 50,
    repeat_delay = 150,
    accel_profile = "flat",
    force_no_accel = false,

    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.2,
      disable_while_typing = false,
      clickfinger_behavior = true
    },

    sensitivity = 0
  }
})

hl.config({
  binds = {
    scroll_event_delay = 10,
    hide_special_on_workspace_change = true,
    movefocus_cycles_groupfirst = true
  }
})

hl.config({
  general = {

    gaps_in = 2,
    gaps_out = 4,
    border_size = 2,
    col = {
      active_border = {
        colors = {
          helper.rgba(theme.colour.blue, "AA"),
          helper.rgba(theme.colour.magenta, "AA")
        },
        angle = 45
      },
      inactive_border = helper.rgba(theme.colour.background, "AA")
    },
    layout = "master",
    allow_tearing = true
  }
})

hl.config({
  decoration = {
    rounding = 5,
    rounding_power = 4.0,
    blur = {enabled = true, size = 3, passes = 1}

    -- #     drop_shadow = yes
    -- #     shadow_range = 4
    -- #     shadow_render_power = 3
    -- #     col.shadow = rgba(1a1a1aee)
  }
})

hl.config({
  master = {mfact = 0.5},
  scrolling = {
    wrap_focus = false,
    explicit_column_widths = "0.5, 1.0",
    follow_focus = false
  }
})

hl.config({
  gestures = {
    workspace_swipe_use_r = false,
    workspace_swipe_forever = true,
    workspace_swipe_create_new = false
  }
})

hl.config({
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    focus_on_activate = true,
    key_press_enables_dpms = true
  }
})

hl.config({debug = {disable_logs = false, disable_time = false}})

hl.device({name = "elan1201:00-04f3:3098-touchpad", sensitivity = 0.8})

hl.config({
  group = {
    drag_into_group = 2,
    group_on_movetoworkspace = true,
    merge_floated_into_tiled_on_groupbar = true,
    col = {
      border_active = {
        colors = {
          helper.rgba(theme.colour.blue, "AA"),
          helper.rgba(theme.colour.magenta, "AA")
        },
        angle = 45
      },
      border_inactive = helper.rgba(theme.colour.background, "AA")
    },
    groupbar = {
      gradients = true,
      gradient_rounding = 5,
      gradient_rounding_power = 4.0,
      gradient_round_only_edges = true,
      gaps_in = 0,
      gaps_out = 0,
      keep_upper_gap = false,
      height = 20,
      indicator_height = 0,
      font_size = 12,
      text_color = helper.rgba(theme.colour.foreground, "FF"),
      col = {
        active = helper.rgba(theme.colour.blue, "FF"),
        inactive = helper.rgba(theme.colour.background, "FF")
      }
    }
  }
})

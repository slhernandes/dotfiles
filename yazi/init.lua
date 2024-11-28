require("git"):setup()

THEME.git = THEME.git or {}

THEME.git = {
  modified = ui.Style():fg("blue"),
  modified_sign = "",
  added = ui.Style():fg("purple"),
  added_sign = "",
  deleted = ui.Style():fg("red"),
  deleted_sign = "",
  ignored = ui.Style():fg("white"),
  ignored_sign = "",
  updated = ui.Style():fg("yellow"),
  updated_sign = "",
}

require("starship"):setup({ config_file = "$HOME/.config/starship.toml" })

require("full-border"):setup({
  type = ui.Border.ROUNDED
})

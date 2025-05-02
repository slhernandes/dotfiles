local wezterm = require('wezterm')
local appearance = require('appearance')
local bindings = require('bindings')

-- plugins
local sessionizer = wezterm.plugin.require(
                        "https://github.com/ElCapitanSponge/sessionizer.wezterm")
local bar = wezterm.plugin
                .require("https://github.com/adriankarlen/bar.wezterm")

local config = {
  color_scheme = 'Tokyo Night Storm',
  initial_rows = 47,
  initial_cols = 191,
  enable_wayland = true
}

local projects = {
  "~/dotfiles", "~/Dokumente", "~/Dokumente/srcs", "~/Dokumente/tsn-testbed"
}

appearance.set_appearance(config, 'Tokyo Night Storm')
bindings.set_bindings(config)

sessionizer.set_projects(projects)
sessionizer.configure(config)

bar.apply_to_config(config, {
  modules = {
    spotify = {enabled = false},
    pane = {enabled = false},
    username = {enabled = false},
    hostname = {enabled = false}
  }
})

-- config.default_prog = { '/home/samuelhernandes/.config/tmux/wezbin/tmux-start' }
return config

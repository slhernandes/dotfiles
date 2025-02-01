local wezterm = require('wezterm')

local module = {}

---Apply colorscheme
--@param config Config
--@param cs string
local function apply_colorscheme(config, cs)
  config.color_scheme = cs
  config.window_background_opacity = 0.9
end

---Tab bar config
--@param config Config
local function configure_tab_bar(config)
  config.use_fancy_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_bar_at_bottom = true
end

---Window padding config
--@param config Config
--@param l int
--@param r int
--@param u int
--@param d int
local function configure_window_padding(config, l, r, u, d)
  config.window_padding = {
    left = l,
    right = r,
    top = u,
    bottom = d,
  }
end

---Fonts config
--@param config Config
local function set_fonts(config)
  config.font = wezterm.font_with_fallback {
    'Fira Code',
    'FiraCode Nerd Font Mono',
    'nonicons',
    'Hasklug Nerd Font',
    'Noto Color Emoji',
  }
  config.harfbuzz_features = {'ss01', 'ss02', 'ss03', 'ss05', 'ss09'}
end

local function get_current_working_dir(tab)
  local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = '' }
  local HOME_DIR = os.getenv("HOME")

  if current_dir.file_path == HOME_DIR then
    return "~"
  else
    return string.gsub(current_dir.file_path, "/(.*/)(.*)/", "%2")
  end
end

---Set appearance of the terminal
--@param
function module.set_appearance(config, cs)
  apply_colorscheme(config, cs)
--  configure_tab_bar(config)
  configure_window_padding(config, 0, 0, 0, 0)
  set_fonts(config)
  wezterm.on(
  'format-tab-title',
  function(tab, _, _, _, _, _)
    local title = get_current_working_dir(tab)
    if tab.is_active then
      return {
        { Text = " [" .. title .. "] "},
      }
    end
    return {
      { Text = " " .. title .. " "},
    }
  end
  )
end

return module

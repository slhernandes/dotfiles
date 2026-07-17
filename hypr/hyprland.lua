-- GLOBALS
Terminal = "ghostty -e " .. os.getenv("HOME") .. "/.config/tmux/bin/tmux-start"
GuiEditor = "emacsclient --create-frame"
Browser = "firefox -P default-release --setDefaultBrowser"
ConfigDir = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config"
HyprDir = ConfigDir .. "/hypr"
ScriptDir = HyprDir .. "/scripts"
MainMod = "SUPER "
ShaderPath = ConfigDir .. "/ghostty/shaders/retro.glsl"
--
require("configs")

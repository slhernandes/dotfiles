local term = "ghostty --custom-shader=" .. ShaderPath .. " -e "
local module = {}
module.suffixes = {
  {name = "magic", key = nil, cmd = nil},
  {name = "btop", key = "B", cmd = term .. "btop"},
  {name = "firefox", key = "F", cmd = "firefox --name=firefox_sp -P scratchpad"},
  {name = "wezterm", key = "T", cmd = "wezterm start --class=wezterm_sp"},
  {name = "yazi", key = "R", cmd = term .. "yazi"},
  {name = "ferdium", key = "Y", cmd = "ferdium"},
  {name = "ncmpcpp", key = "N", cmd = term .. "ncmpcpp"},
  {name = "wireless", key = "W", cmd = {term .. "bluetuith", term .. "nmtui"}}
}
return module

--platform.lua
local w = require 'wezterm'

return {
  is_win = string.find(w.target_triple, 'windows') ~= nil,
  is_linux = string.find(w.target_triple, 'linux') ~= nil,
  is_mac = string.find(w.target_triple, 'apple') ~= nil,
}

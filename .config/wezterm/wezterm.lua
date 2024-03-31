-- https://wezfurlong.org/wezterm/config/files.html

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'

-- https://github.com/wez/wezterm/issues/3958#issuecomment-1908436077
config.enable_wayland = false
config.front_end = "OpenGL"

-- and finally, return the configuration to wezterm
return config

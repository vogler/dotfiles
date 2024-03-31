-- https://wezfurlong.org/wezterm/config/files.html
-- config will be reloaded when this file is changed, if not force with ctrl-shift-r
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Needed to start on ChromeOS: https://github.com/wez/wezterm/issues/3958#issuecomment-1908436077
config.enable_wayland = false
config.front_end = "OpenGL"

config.window_padding = { left = 5, right = 0, top = 0, bottom = 0 }

-- config.font = wezterm.font("DejaVu Sans Mono") -- default was 'JetBrains Mono' which somehow looks better here than in kitty; DejaVu looks too cramped
config.font_size = 11.0 -- default is 12.0
config.adjust_window_size_when_changing_font_size = false

config.use_fancy_tab_bar = false

-- 965 themes with preview: https://wezfurlong.org/wezterm/colorschemes
-- Nicer overview: https://gogh-co.github.io/Gogh/
config.color_scheme = 'Chalk (Gogh)'
config.color_scheme = 'Dracula (Gogh)'
config.color_scheme = 'Nord (Gogh)'
config.color_scheme = 'SpaceGray Eighties'
config.color_scheme = 'Everforest Dark (Gogh)'
config.color_scheme = 'Gruvbox Dark (Gogh)'
config.color_scheme = 'Catppuccin Macchiato (Gogh)'
config.color_scheme = 'Catppuccin Frappé (Gogh)'
config.color_scheme = 'Solarized Dark (Gogh)'

-- save/restore session
-- https://github.com/wez/wezterm/issues/3237 https://github.com/danielcopper/wezterm-session-manager

-- Session manager above not needed, can attach to a socket/server like in tmux: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
config.unix_domains = { { name = 'unix', }, }
-- This causes `wezterm` to act as though it was started as `wezterm connect unix` by default, connecting to the unix domain on startup. However, this doesn't work when starting the Linux app from ChromeOS instead of a terminal.
config.default_gui_startup_args = { 'connect', 'unix' }
-- fix for start from menu: https://github.com/wez/wezterm/issues/2933#issuecomment-1375829700
wezterm.on('gui-startup', function(cmd)
  local unix = wezterm.mux.get_domain("unix")
  wezterm.mux.set_default_domain(unix)
  unix:attach()
end)

return config

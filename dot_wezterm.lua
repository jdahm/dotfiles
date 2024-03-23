-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'Afterglow'
config.font = wezterm.font 'Hack Nerd Font Mono'
config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
config.font_size = 14.0
config.scrollback_lines = 5000
config.hide_tab_bar_if_only_one_tab = true

-- and finally, return the configuration to wezterm
return config

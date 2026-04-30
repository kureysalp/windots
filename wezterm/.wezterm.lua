-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- appereance
config.window_decorations = "NONE | RESIZE"
config.window_background_opacity = 0.9

-- config.window_padding = {
-- 	left = 0,
-- 	right = 0,
-- 	top = 0,
-- 	bottom = 0,
-- }


-- color and theme
config.color_scheme = "tokyonight_night"
-- config.color_scheme = "Cloud (terminal.sexy)"
config.colors = {
    	cursor_border = "#bea3c7",
        cursor_bg = "#bea3c7",
}

-- font settings
config.font_size = 10
config.font = wezterm.font('CaskaydiaCove Nerd Font')

-- miscellaneous
config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.animation_fps = 1
config.cursor_blink_rate = 500 

config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
  { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'C', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'UpArrow', mods = 'SHIFT', action = wezterm.action.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollByLine(1) },
  { key = 'PageUp', mods = 'SHIFT', action = wezterm.action.ScrollByPage(-1) },
  { key = 'PageDown', mods = 'SHIFT', action = wezterm.action.ScrollByPage(1) },
}

-- Finally, return the configuration to wezterm:
return config
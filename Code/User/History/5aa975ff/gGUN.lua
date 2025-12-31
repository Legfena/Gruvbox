-- WezTerm Config - Gruvbox Dark Hard with animations and smooth scrolling

local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Font
config.font = wezterm.font('Gohu GohuFont')
config.font_size = 10.0

-- Window
config.window_decorations = "NONE"
config.window_background_opacity = 0.95
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}

-- Smooth scrolling
config.enable_scroll_bar = false
config.min_scroll_bar_height = '2cell'
config.scrollback_lines = 10000

-- Animations (smooth and slick)
config.animation_fps = 60
config.max_fps = 60
config.front_end = "WebGpu"

-- Cursor
config.default_cursor_style = 'SteadyBlock'
config.cursor_blink_rate = 0

-- Tab bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 32

-- Colors - Gruvbox Dark Hard (Brighter)
config.colors = {
  foreground = '#fbf1c7',
  background = '#1d2021',
  
  cursor_bg = '#fbf1c7',
  cursor_fg = '#1d2021',
  cursor_border = '#fbf1c7',
  
  selection_fg = '#1d2021',
  selection_bg = '#fbf1c7',
  
  scrollbar_thumb = '#504945',
  
  split = '#504945',
  
  ansi = {
    '#32302f', -- black
    '#fb4934', -- red
    '#b8bb26', -- green
    '#fabd2f', -- yellow
    '#83a598', -- blue
    '#d3869b', -- magenta
    '#8ec07c', -- cyan
    '#ebdbb2', -- white
  },
  
  brights = {
    '#7c6f64', -- bright black
    '#fb4934', -- bright red
    '#b8bb26', -- bright green
    '#fabd2f', -- bright yellow
    '#83a598', -- bright blue
    '#d3869b', -- bright magenta
    '#8ec07c', -- bright cyan
    '#fbf1c7', -- bright white
  },
  
  tab_bar = {
    background = '#1d2021',
    
    active_tab = {
      bg_color = '#fabd2f',
      fg_color = '#1d2021',
      intensity = 'Bold',
    },
    
    inactive_tab = {
      bg_color = '#504945',
      fg_color = '#ebdbb2',
    },
    
    inactive_tab_hover = {
      bg_color = '#665c54',
      fg_color = '#fbf1c7',
    },
    
    new_tab = {
      bg_color = '#3c3836',
      fg_color = '#ebdbb2',
    },
    
    new_tab_hover = {
      bg_color = '#504945',
      fg_color = '#fbf1c7',
    },
  },
}

-- Shell
config.default_prog = { '/usr/bin/zsh' }

-- Mouse
config.hide_mouse_cursor_when_typing = true

-- Copy on select
config.selection_word_boundary = ' \t\n{}[]()"\':;,│'

-- Keybindings
config.keys = {
  -- Copy/Paste
  { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },
  
  -- Font size
  { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
  
  -- Tabs
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = wezterm.action.CloseCurrentTab{ confirm = false } },
  
  -- Panes
  { key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal{ domain = 'CurrentPaneDomain' } },
  { key = 'D', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical{ domain = 'CurrentPaneDomain' } },
}

-- Performance
config.scrollback_lines = 10000

return config
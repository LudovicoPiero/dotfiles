local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font_with_fallback({
  "Iosevka",
  "Symbols Nerd Font",
  "Noto Emoji",
})
config.font_size = 15.0

-- Wayland & UI Settings
-- config.enable_wayland = true
config.enable_scroll_bar = false
config.check_for_updates = false
config.default_cursor_style = "SteadyBlock"

-- Tab Bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Window Settings
config.scrollback_lines = 10000
config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.window_background_opacity = 0.9
config.use_ime = true
config.warn_about_missing_glyphs = false

-- =========================================================
-- 2. COLORS (Catppuccin Mocha Base16)
-- =========================================================
local colors = {
  base00 = "#1a1b26", -- Background
  base01 = "#24283b", -- UI Background / Lighter (Storm-ish)
  base02 = "#414868", -- Selection/Comments
  base03 = "#565f89", -- Comments/Dark Text
  base04 = "#cfc9c2", -- UI text
  base05 = "#c0caf5", -- Foreground (Text)
  base06 = "#e0af68", -- Cursor (using Orange/Yellow for visibility)
  base07 = "#c0caf5", -- White
  base08 = "#f7768e", -- Red
  base09 = "#ff9e64", -- Orange
  base0A = "#e0af68", -- Yellow
  base0B = "#9ece6a", -- Green
  base0C = "#7dcfff", -- Cyan
  base0D = "#7aa2f7", -- Blue
  base0E = "#bb9af7", -- Magenta
  base0F = "#f7768e", -- Flamingo/Red alt
}

-- Window Frame (Title bar / Borders)
config.window_frame = {
  active_titlebar_bg = colors.base03,
  active_titlebar_fg = colors.base05,
  active_titlebar_border_bottom = colors.base03,
  border_left_color = colors.base01,
  border_right_color = colors.base01,
  border_bottom_color = colors.base01,
  border_top_color = colors.base01,
  button_bg = colors.base01,
  button_fg = colors.base05,
  button_hover_bg = colors.base05,
  button_hover_fg = colors.base03,
  inactive_titlebar_bg = colors.base01,
  inactive_titlebar_fg = colors.base05,
  inactive_titlebar_border_bottom = colors.base03,
}

-- Terminal Colors
config.colors = {
  ansi = {
    colors.base00, colors.base08, colors.base0B, colors.base0A,
    colors.base0D, colors.base0E, colors.base0C, colors.base05,
  },
  brights = {
    colors.base03, colors.base08, colors.base0B, colors.base0A,
    colors.base0D, colors.base0E, colors.base0C, colors.base07,
  },
  background = colors.base00,
  foreground = colors.base05,
  cursor_bg = colors.base05,
  cursor_fg = colors.base00,
  compose_cursor = colors.base06,
  scrollbar_thumb = colors.base01,
  selection_bg = colors.base05,
  selection_fg = colors.base00,
  split = colors.base03,
  visual_bell = colors.base09,

  tab_bar = {
    background = colors.base01,
    inactive_tab_edge = colors.base01,
    active_tab = {
      bg_color = colors.base00,
      fg_color = colors.base05,
    },
    inactive_tab = {
      bg_color = colors.base03,
      fg_color = colors.base05,
    },
    inactive_tab_hover = {
      bg_color = colors.base05,
      fg_color = colors.base00,
    },
    new_tab = {
      bg_color = colors.base03,
      fg_color = colors.base05,
    },
    new_tab_hover = {
      bg_color = colors.base05,
      fg_color = colors.base00,
    },
  },
}

config.command_palette_bg_color = colors.base01
config.command_palette_fg_color = colors.base05
config.command_palette_font_size = 12.0

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Scrolling
  { key = "UpArrow",   mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
  { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },

  -- Pane Navigation (Vim style)
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },

  -- Copy Mode
  { key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },

  -- Command Palette
  { key = "p", mods = "CMD|SHIFT", action = wezterm.action.ActivateCommandPalette },

  -- Splits (v = down, ; = right)
  { key = "v", mods = "LEADER", action = wezterm.action.SplitPane({ direction = "Down",  size = { Percent = 45 } }) },
  { key = ";", mods = "LEADER", action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 45 } }) },

  -- Tab Management
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },

  -- Send literal Ctrl+A
  { key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendString("\x01") },
}

config.hyperlink_rules = {
  { regex = "\\((\\w+://\\S+)\\)",     format = "$1", highlight = 1 },
  { regex = "\\[(\\w+://\\S+)\\]",     format = "$1", highlight = 1 },
  { regex = "\\{(\\w+://\\S+)\\}",     format = "$1", highlight = 1 },
  { regex = "<(\\w+://\\S+)>",         format = "$1", highlight = 1 },
  { regex = "[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)", format = "$1", highlight = 1 },
  { regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b", format = "mailto:$0" },
}

return config

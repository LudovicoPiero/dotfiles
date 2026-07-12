{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.wezterm;
  c = config.mine.theme.colors;
in
{
  options.mine.wezterm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable wezterm configuration.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wezterm;
      description = "The wezterm package to install.";
    };
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ cfg.package ];

      xdg.config.files."wezterm/wezterm.lua".text = ''
        local wezterm = require("wezterm")

        local config = {}
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.font = wezterm.font_with_fallback({
          "${config.mine.fonts.terminal.name}",
          "Symbols Nerd Font",
          "Noto Color Emoji",
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
        config.window_background_opacity = 1.0
        config.use_ime = true
        config.warn_about_missing_glyphs = false

        -- Window Frame (title bar / borders)
        config.window_frame = {
          active_titlebar_bg = "${c.base03}",
          active_titlebar_fg = "${c.base05}",
          active_titlebar_border_bottom = "${c.base03}",
          border_left_color = "${c.base01}",
          border_right_color = "${c.base01}",
          border_bottom_color = "${c.base01}",
          border_top_color = "${c.base01}",
          button_bg = "${c.base01}",
          button_fg = "${c.base05}",
          button_hover_bg = "${c.base05}",
          button_hover_fg = "${c.base03}",
          inactive_titlebar_bg = "${c.base01}",
          inactive_titlebar_fg = "${c.base05}",
          inactive_titlebar_border_bottom = "${c.base03}",
        }

        -- Terminal Colors
        config.colors = {
          ansi = {
            "${c.base00}", "${c.base08}", "${c.base0B}", "${c.base0A}",
            "${c.base0D}", "${c.base0E}", "${c.base0C}", "${c.base05}",
          },
          brights = {
            "${c.base03}", "${c.base08}", "${c.base0B}", "${c.base0A}",
            "${c.base0D}", "${c.base0E}", "${c.base0C}", "${c.base07}",
          },
          background = "${c.base00}",
          foreground = "${c.base05}",
          cursor_bg = "${c.base05}",
          cursor_fg = "${c.base00}",
          compose_cursor = "${c.base06}",
          scrollbar_thumb = "${c.base01}",
          selection_bg = "${c.base05}",
          selection_fg = "${c.base00}",
          split = "${c.base03}",
          visual_bell = "${c.base09}",

          tab_bar = {
            background = "${c.base01}",
            inactive_tab_edge = "${c.base01}",
            active_tab = {
              bg_color = "${c.base00}",
              fg_color = "${c.base05}",
            },
            inactive_tab = {
              bg_color = "${c.base03}",
              fg_color = "${c.base05}",
            },
            inactive_tab_hover = {
              bg_color = "${c.base05}",
              fg_color = "${c.base00}",
            },
            new_tab = {
              bg_color = "${c.base03}",
              fg_color = "${c.base05}",
            },
            new_tab_hover = {
              bg_color = "${c.base05}",
              fg_color = "${c.base00}",
            },
          },
        }

        config.command_palette_bg_color = "${c.base01}"
        config.command_palette_fg_color = "${c.base05}"

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
      '';
    };
  };
}

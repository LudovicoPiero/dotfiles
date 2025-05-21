{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.wezterm;
in
{
  options.mine.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  config = mkIf cfg.enable {
    hj = {
      packages = [ pkgs.wezterm ];

      files = {
        ".config/wezterm/wezterm.lua".text = ''
          local wezterm = require("wezterm")

          -- Watch the config directory for changes and reload automatically
          wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

          -- Initialize the main config table, supporting both release and nightly
          local config = {}
          if wezterm.config_builder then
            config = wezterm.config_builder()
          end

          local function make_user_config()
            return {
              -- Fonts (intentionally unchanged)
              font = wezterm.font_with_fallback({
                "${config.mine.fonts.terminal.name} Semibold",
                "${config.mine.fonts.icon.name}",
                "${config.mine.fonts.emoji.name}",
              }),

              -- Wayland and UI settings
              enable_wayland = true,
              enable_scroll_bar = false,
              enable_kitty_keyboard = true,
              check_for_updates = false,
              default_cursor_style = "SteadyBlock",
              use_fancy_tab_bar = false,
              hide_tab_bar_if_only_one_tab = true,
              enable_tab_bar = true,
              scrollback_lines = 10000,
              adjust_window_size_when_changing_font_size = false,
              audible_bell = "Disabled",
              clean_exit_codes = { 130 },
              window_background_opacity = ${toString config.vars.opacity},

              -- Window frame styling
              window_frame = {
                active_titlebar_bg = "#${palette.base03}",
                active_titlebar_fg = "#${palette.base05}",
                active_titlebar_border_bottom = "#${palette.base03}",
                border_left_color = "#${palette.base01}",
                border_right_color = "#${palette.base01}",
                border_bottom_color = "#${palette.base01}",
                border_top_color = "#${palette.base01}",
                button_bg = "#${palette.base01}",
                button_fg = "#${palette.base05}",
                button_hover_bg = "#${palette.base05}",
                button_hover_fg = "#${palette.base03}",
                inactive_titlebar_bg = "#${palette.base01}",
                inactive_titlebar_fg = "#${palette.base05}",
                inactive_titlebar_border_bottom = "#${palette.base03}",
              },

              -- Tab bar colors
              colors = {
                ansi = {
                  "#${palette.base00}",
                  "#${palette.base08}",
                  "#${palette.base0B}",
                  "#${palette.base0A}",
                  "#${palette.base0D}",
                  "#${palette.base0E}",
                  "#${palette.base0C}",
                  "#${palette.base05}",
                },
                brights = {
                  "#${palette.base03}",
                  "#${palette.base08}",
                  "#${palette.base0B}",
                  "#${palette.base0A}",
                  "#${palette.base0D}",
                  "#${palette.base0E}",
                  "#${palette.base0C}",
                  "#${palette.base07}",
                },
                background = "#${palette.base00}",
                cursor_bg = "#${palette.base05}",
                cursor_fg = "#${palette.base00}",
                compose_cursor = "#${palette.base06}",
                foreground = "#${palette.base05}",
                scrollbar_thumb = "#${palette.base01}",
                selection_bg = "#${palette.base05}",
                selection_fg = "#${palette.base00}",
                split = "#${palette.base03}",
                visual_bell = "#${palette.base09}",
                tab_bar = {
                  background = "#${palette.base01}",
                  inactive_tab_edge = "#${palette.base01}",
                  active_tab = {
                    bg_color = "#${palette.base00}",
                    fg_color = "#${palette.base05}",
                  },
                  inactive_tab = {
                    bg_color = "#${palette.base03}",
                    fg_color = "#${palette.base05}",
                  },
                  inactive_tab_hover = {
                    bg_color = "#${palette.base05}",
                    fg_color = "#${palette.base00}",
                  },
                  new_tab = {
                    bg_color = "#${palette.base03}",
                    fg_color = "#${palette.base05}",
                  },
                  new_tab_hover = {
                    bg_color = "#${palette.base05}",
                    fg_color = "#${palette.base00}",
                  },
                },
              },

              -- Command palette
              command_palette_bg_color = "#${palette.base01}",
              command_palette_fg_color = "#${palette.base05}",
              command_palette_font_size = ${toString config.mine.fonts.size},

              -- Leader key and shortcuts
              leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
              keys = {
                -- Scrolling
                { key = "UpArrow",   mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
                { key = "DownArrow", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },
                -- Pane navigation
                { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
                { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
                { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
                { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
                -- Copy mode
                { key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
                -- Command palette
                { key = "p", mods = "CMD|SHIFT", action = wezterm.action.ActivateCommandPalette },
                -- Splits
                { key = "v", mods = "LEADER", action = wezterm.action.SplitPane({ direction = "Down",  size = { Percent = 45 } }) },
                { key = ";", mods = "LEADER", action = wezterm.action.SplitPane({ direction = "Right", size = { Percent = 45 } }) },
                -- Tabs
                { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
                -- Tab switching
                { key = "1", mods = "LEADER",      action = wezterm.action({ ActivateTab = 0 }) },
                { key = "2", mods = "LEADER",      action = wezterm.action({ ActivateTab = 1 }) },
                { key = "3", mods = "LEADER",      action = wezterm.action({ ActivateTab = 2 }) },
                { key = "4", mods = "LEADER",      action = wezterm.action({ ActivateTab = 3 }) },
                { key = "5", mods = "LEADER",      action = wezterm.action({ ActivateTab = 4 }) },
                { key = "6", mods = "LEADER",      action = wezterm.action({ ActivateTab = 5 }) },
                { key = "7", mods = "LEADER",      action = wezterm.action({ ActivateTab = 6 }) },
                { key = "8", mods = "LEADER",      action = wezterm.action({ ActivateTab = 7 }) },
                -- Send Ctrl+A
                { key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendString("\x01") },
              },
            }
          end

          for k, v in pairs(make_user_config()) do
            config[k] = v
          end

          -- Add URL hyperlink rules for Markdown handling
          -- Source: https://github.com/wez/wezterm/issues/3803#issuecomment-1608954312
          config.hyperlink_rules = {
            { regex = '\\((\\w+://\\S+)\\)',     format = '$1', highlight = 1 },
            { regex = '\\[(\\w+://\\S+)\\]',     format = '$1', highlight = 1 },
            { regex = '\\{(\\w+://\\S+)\\}',     format = '$1', highlight = 1 },
            { regex = '<(\\w+://\\S+)>',            format = '$1', highlight = 1 },
            { regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',format='$1', highlight = 1 },
            { regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b', format = 'mailto:$0' },
          }

          -- Load and apply user-specific overrides if available
          if wezterm.config_builder then
            if type(user_conf) == "table" then
              for k, v in pairs(user_conf) do
                config[k] = v
              end
            end
          end

          return config
        '';
      };
    };
  };
}

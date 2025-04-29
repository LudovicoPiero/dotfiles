{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.wezterm;
in
{
  options.myOptions.wezterm = {
    enable = mkEnableOption "wezterm" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.vars.username} =
      { config, osConfig, ... }:
      let
        inherit (config) colorScheme;
        inherit (colorScheme) palette;
      in
      {
        programs.wezterm = {
          enable = true;

          colorSchemes.${colorScheme.slug} = {
            ansi = [
              "#${palette.base00}"
              "#${palette.base08}"
              "#${palette.base0B}"
              "#${palette.base0A}"
              "#${palette.base0D}"
              "#${palette.base0E}"
              "#${palette.base0C}"
              "#${palette.base05}"
            ];
            brights = [
              "#${palette.base03}"
              "#${palette.base08}"
              "#${palette.base0B}"
              "#${palette.base0A}"
              "#${palette.base0D}"
              "#${palette.base0E}"
              "#${palette.base0C}"
              "#${palette.base07}"
            ];
            background = "#${palette.base00}";
            cursor_bg = "#${palette.base05}";
            cursor_fg = "#${palette.base00}";
            compose_cursor = "#${palette.base06}";
            foreground = "#${palette.base05}";
            scrollbar_thumb = "#${palette.base01}";
            selection_bg = "#${palette.base05}";
            selection_fg = "#${palette.base00}";
            split = "#${palette.base03}";
            visual_bell = "#${palette.base09}";
            tab_bar = {
              background = "#${palette.base01}";
              inactive_tab_edge = "#${palette.base01}";
              active_tab = {
                bg_color = "#${palette.base00}";
                fg_color = "#${palette.base05}";
              };
              inactive_tab = {
                bg_color = "#${palette.base03}";
                fg_color = "#${palette.base05}";
              };
              inactive_tab_hover = {
                bg_color = "#${palette.base05}";
                fg_color = "#${palette.base00}";
              };
              new_tab = {
                bg_color = "#${palette.base03}";
                fg_color = "#${palette.base05}";
              };
              new_tab_hover = {
                bg_color = "#${palette.base05}";
                fg_color = "#${palette.base00}";
              };
            };
          };
        };

        # Stolen from stylix
        # https://github.com/danth/stylix/blob/master/modules/wezterm/hm.nix
        xdg.configFile."wezterm/wezterm.lua".text = lib.mkForce ''
          local wezterm = require("wezterm")
          wezterm.add_to_config_reload_watch_list(wezterm.config_dir)
          -- Allow working with both the current release and the nightly
          local config = {}
          if wezterm.config_builder then
            config = wezterm.config_builder()
          end
          local stylix_base_config = wezterm.config_builder()
          stylix_base_config = {
            font = wezterm.font_with_fallback({
              "${osConfig.myOptions.fonts.main.name} Semibold",
              "${osConfig.myOptions.fonts.icon.name}",
              "${osConfig.myOptions.fonts.emoji.name}",
            }),
            enable_wayland = true,
            enable_scroll_bar = false,
            enable_kitty_keyboard = true,
            check_for_updates = false,
            default_cursor_style = "SteadyBlock",
            enable_tab_bar = true,
            hide_tab_bar_if_only_one_tab = true,
            scrollback_lines = 10000,
            adjust_window_size_when_changing_font_size = false,
            audible_bell = "Disabled",
            use_fancy_tab_bar = false,
            clean_exit_codes = { 130 },
            window_background_opacity = ${toString osConfig.vars.opacity},
            color_scheme = "${colorScheme.slug}",
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
            colors = {
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
            command_palette_bg_color = "#${palette.base01}",
            command_palette_fg_color = "#${palette.base05}",
            command_palette_font_size = ${toString osConfig.myOptions.fonts.size},

            leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
            keys = {
              { key = "UpArrow",   mods = "SHIFT",  action = wezterm.action({ ScrollByLine = -1 }) },
              { key = "DownArrow", mods = "SHIFT",  action = wezterm.action({ ScrollByLine = 1 }) },
              { key = "h",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
              { key = "l",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
              { key = "j",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
              { key = "k",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
              {
                key = "v",
                mods = "LEADER",
                action = wezterm.action.SplitPane({
                  top_level = true,
                  direction = "Down",
                  size = { Percent = 45 },
                }),
              },
              {
                key = ";",
                mods = "LEADER",
                action = wezterm.action.SplitPane({
                  top_level = true,
                  direction = "Right",
                  size = { Percent = 45 },
                }),
              },
              { key = "c", mods = "LEADER",      action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
              { key = "1", mods = "LEADER",      action = wezterm.action({ ActivateTab = 0 }) },
              { key = "2", mods = "LEADER",      action = wezterm.action({ ActivateTab = 1 }) },
              { key = "3", mods = "LEADER",      action = wezterm.action({ ActivateTab = 2 }) },
              { key = "4", mods = "LEADER",      action = wezterm.action({ ActivateTab = 3 }) },
              { key = "5", mods = "LEADER",      action = wezterm.action({ ActivateTab = 4 }) },
              { key = "6", mods = "LEADER",      action = wezterm.action({ ActivateTab = 5 }) },
              { key = "7", mods = "LEADER",      action = wezterm.action({ ActivateTab = 6 }) },
              { key = "8", mods = "LEADER",      action = wezterm.action({ ActivateTab = 7 }) },
              { key = "9", mods = "LEADER",      action = wezterm.action({ ActivateTab = -1 }) },
              { key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
            },
          }
          for key, value in pairs(stylix_base_config) do
              config[key] = value
          end
          local function stylix_wrapped_config()
              ${config.programs.wezterm.extraConfig}
          end
          local stylix_user_config = stylix_wrapped_config()
          if stylix_user_config then
              for key, value in pairs(stylix_user_config) do
                  config[key] = value
              end
          end
          return config
        '';
      }; # For Home-Manager options
  };
}

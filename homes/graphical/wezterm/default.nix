{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config) colorScheme;
  inherit (colorScheme) colors;
in {
  programs.wezterm = {
    enable = true;
    package = inputs.self.packages.${pkgs.system}.wezterm;
    colorSchemes = {
      "${colorScheme.slug}" = {
        ansi = [
          "${colors.base00}"
          "${colors.base08}"
          "${colors.base0A}"
          "${colors.base0D}"
          "${colors.base0E}"
          "${colors.base0C}"
          "${colors.base0C}"
          "${colors.base05}"
        ];
        brights = [
          "${colors.base03}"
          "${colors.base08}"
          "${colors.base0B}"
          "${colors.base0A}"
          "${colors.base0D}"
          "${colors.base0E}"
          "${colors.base0C}"
          "${colors.base07}"
        ];
        tab_bar = {
          background = "#${colors.base01}";
          inactive_tab_edge = "#${colors.base01}";
          active_tab = {
            bg_color = "#${colors.base03}";
            fg_color = "#${colors.base05}";
          };
          inactive_tab = {
            bg_color = "#${colors.base00}";
            fg_color = "#${colors.base05}";
          };
          inactive_tab_hover = {
            bg_color = "#${colors.base05}";
            fg_color = "#${colors.base00}";
          };
          new_tab = {
            bg_color = "#${colors.base00}";
            fg_color = "#${colors.base05}";
          };
          new_tab_hover = {
            bg_color = "#${colors.base05}";
            fg_color = "#${colors.base00}";
          };
        };
        foreground = "#${colors.base05}";
        background = "#${colors.base00}";
        cursor_fg = "#${colors.base05}";
        cursor_bg = "#${colors.base05}";
        compose_cursor = "${colors.base06}";
        scrollbar_thumb = "${colors.base01}";
        cursor_border = "#${colors.base05}";
        selection_fg = "#${colors.base00}";
        selection_bg = "#${colors.base05}";
        split = "${colors.base03}";
        visual_bell = "${colors.base09}";
      };
    };
    extraConfig = ''
      return {
        font = wezterm.font_with_fallback({
          {
            family = 'Monaspace Neon',
            weight = 'Medium',
            harfbuzz_features = {'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'calt', 'dlig'},
          },
          "Material Design Icons",
          "Noto Color Emoji",
        }),
        font_size = 12.0,
        window_background_opacity = 0.88,
        color_scheme = "${colorScheme.slug}",
        enable_scroll_bar = false,
        check_for_updates = false,
        default_cursor_style = "SteadyBlock",
        enable_tab_bar = true,
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        adjust_window_size_when_changing_font_size = false,
        audible_bell = "Disabled",
        use_fancy_tab_bar = false,
        clean_exit_codes = { 130 },
        window_frame = {
          active_titlebar_bg = "${colors.base03}",
          active_titlebar_fg = "${colors.base05}",
          active_titlebar_border_bottom = "${colors.base03}",
          border_left_color = "${colors.base01}",
          border_right_color = "${colors.base01}",
          border_bottom_color = "${colors.base01}",
          border_top_color = "${colors.base01}",
          button_bg = "${colors.base01}",
          button_fg = "${colors.base05}",
          button_hover_bg = "${colors.base05}",
          button_hover_fg = "${colors.base03}",
          inactive_titlebar_bg = "${colors.base01}",
          inactive_titlebar_fg = "${colors.base05}",
          inactive_titlebar_border_bottom = "${colors.base03}",
        },
        command_palette_bg_color = "${colors.base01}",
        command_palette_fg_color = "${colors.base05}",
        command_palette_font_size = 12.0,

        --window_padding = {
        --  left = 5,
        --  right = 5,
        --  top = 5,
        --  bottom = 5,
        --},

        leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
        keys = {
          { key = "UpArrow",   mods = "SHIFT",  action = wezterm.action({ ScrollToPrompt = -1 }) },
          { key = "DownArrow", mods = "SHIFT",  action = wezterm.action({ ScrollToPrompt = 1 }) },
          { key = "h",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
          { key = "l",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
          { key = "j",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
          { key = "k",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },

          -- screen/tmux compat
          { key = "v", mods = "LEADER",      action = wezterm.action({ SplitVertical   = { domain = "CurrentPaneDomain" }, }) },
          { key = ";", mods = "LEADER",      action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" }, }) },
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
          -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
          { key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
        },
      }
    '';
  };
}

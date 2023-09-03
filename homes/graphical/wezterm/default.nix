{config, ...}: let
  inherit (config) colorScheme;
  inherit (colorScheme) colors;
in {
  programs.wezterm = {
    enable = true;
    colorSchemes = {
      "${colorScheme.slug}" = {
        ansi = [
          "${colors.base00}"
          "${colors.base08}"
          "${colors.base0B}"
          "${colors.base0A}"
          "${colors.base0D}"
          "${colors.base0E}"
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
        foreground = "#${colors.base05}";
        background = "#${colors.base00}";
        cursor = "#${colors.base05}";
        cursor_bg = "#${colors.base05}";
        cursor_border = "#${colors.base05}";
        selection_fg = "#${colors.base00}";
        selection_bg = "#${colors.base05}";
      };
    };
    extraConfig = ''
      return {
        font = wezterm.font_with_fallback({
          "JetBrains Mono SemiBold",
          "Material Design Icons",
          "Noto Color Emoji",
        }),
        font_size = 12.0,
        window_background_opacity = 0.8,
        color_scheme = "${colorScheme.slug}",
        enable_scroll_bar = false,
        -- enable_tab_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        scrollback_lines = 10000,
        adjust_window_size_when_changing_font_size = false,
        audible_bell = "Disabled",
        clean_exit_codes = { 130 },

        window_padding = {
          left = 5,
          right = 5,
          top = 5,
          bottom = 5,
        },

        check_for_updates = false,
        default_cursor_style = "SteadyBlock",

        leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
        keys = {
          { key = "UpArrow",   mods = "SHIFT",  action = wezterm.action({ ScrollToPrompt = -1 }) },
          { key = "DownArrow", mods = "SHIFT",  action = wezterm.action({ ScrollToPrompt = 1 }) },
          { key = "h",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
          { key = "l",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
          { key = "j",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
          { key = "k",         mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
          {
            key = ";",
            mods = "LEADER",
            action = wezterm.action({
              SplitHorizontal = { domain = "CurrentPaneDomain" },
            }),
          },
          {
            key = "v",
            mods = "LEADER",
            action = wezterm.action({
              SplitVertical = { domain = "CurrentPaneDomain" },
            }),
          },
        
          -- close tabs
          -- { key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
        
          -- screen/tmux compat
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

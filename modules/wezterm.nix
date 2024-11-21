{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.wezterm;
in
{
  options.myOptions.wezterm = {
    enable = mkEnableOption "wezterm" // {
      default = config.myOptions.hyprland.enable;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.myOptions.vars.username} =
      { config, ... }:
      let
        inherit (config) colorScheme;
        inherit (colorScheme) palette;
      in
      {
        programs.wezterm = {
          enable = true;
          package = inputs.ludovico-nixpkgs.packages.${pkgs.stdenv.hostPlatform.system}.wezterm;
          extraConfig = ''
            return {
              font = wezterm.font_with_fallback({
                "Iosevka q Semibold",
                "Material Design Icons",
                "Noto Color Emoji",
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
              color_scheme = "${colorScheme.slug}",
              window_frame = {
                 active_titlebar_bg = "${palette.base03}",
                 active_titlebar_fg = "${palette.base05}",
                 active_titlebar_border_bottom = "${palette.base03}",
                 border_left_color = "${palette.base01}",
                 border_right_color = "${palette.base01}",
                 border_bottom_color = "${palette.base01}",
                 border_top_color = "${palette.base01}",
                 button_bg = "${palette.base01}",
                 button_fg = "${palette.base05}",
                 button_hover_bg = "${palette.base05}",
                 button_hover_fg = "${palette.base03}",
                 inactive_titlebar_bg = "${palette.base01}",
                 inactive_titlebar_fg = "${palette.base05}",
                 inactive_titlebar_border_bottom = "${palette.base03}",
              },
              command_palette_bg_color = "${palette.base01}",
              command_palette_fg_color = "${palette.base05}",
              command_palette_font_size = 12.0,

              leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
              keys = {
                { key = "UpArrow",   mods = "SHIFT",  action = wezterm.action({ ScrollByLine = -1 }) },
                { key = "DownArrow", mods = "SHIFT",  action = wezterm.action({ ScrollByLine = 1 }) },
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
      }; # For Home-Manager options
  };
}

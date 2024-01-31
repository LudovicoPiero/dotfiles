{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  cfg = config.mine.sway;
  inherit (config.colorScheme) palette;
  inherit (lib) mkEnableOption mkIf optionalString;
in
{
  options.mine.sway = {
    enable = mkEnableOption "sway";
    useSwayFX = mkEnableOption "sway with SwayFX";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      package = if cfg.useSwayFX then pkgs.swayfx else inputs.chaotic.packages.${pkgs.system}.sway_git;
      config = {
        colors = import ./colors.nix { inherit palette; };
        keybindings = import ./keybindings.nix { inherit lib config pkgs; };
        bars = [ ]; # Use waybar
        window = import ./windows.nix;
        output = {
          "*" = {
            adaptive_sync = "on";
          };
          "HDMI-A-1" = {
            scale = "1.5";
          };
        };
        input = {
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            natural_scroll = "enabled";
          };
          "type:keyboard" = {
            xkb_options = "ctrl:nocaps";
            repeat_delay = "200";
            repeat_rate = "30";
          };
        };
        floating = {
          border = 2;
          titlebar = true;
          criteria = [
            { window_role = "pop-up"; }
            { window_role = "bubble"; }
            { window_role = "dialog"; }
            { window_type = "dialog"; }
            { app_id = "lutris"; }
            { app_id = "thunar"; }
            { app_id = "pavucontrol"; }
            { class = ".*.exe"; } # Wine apps
            { class = "steam_app.*"; } # Steam games
            { class = "^Steam$"; } # Steam itself
          ];
        };
        gaps = {
          inner = 3;
          outer = 3;
        };
        fonts = {
          names = [ "Iosevka q" ];
          size = 10.0;
        };
        startup = [
          {
            command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";
          }
          {
            command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";
          }
          { command = "fcitx5 -d --replace"; }
          { command = "mako"; }
          { command = "waybar"; }
          {
            command = "systemctl --user restart swaybg xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk";
          }
        ];
        modifier = "Mod4";
        terminal = "${lib.getExe inputs.self.packages.${pkgs.system}.wezterm}";
        menu = "${pkgs.fuzzel}/bin/fuzzel";
      };
      extraConfig =
        ''
          titlebar_border_thickness 1
          title_align center
          titlebar_padding 2
        ''
        + optionalString cfg.useSwayFX ''
          # SwayFX stuff
          # window corner radius in px
          corner_radius 0

          blur enable
          blur_xray disable
          blur_passes 1
          blur_radius 2

          shadows off
          shadows_on_csd off
          shadow_blur_radius 20
          shadow_color #0000007F

          # inactive window fade amount. 0.0 = no dimming, 1.0 = fully dimmed
          default_dim_inactive 0.0
          dim_inactive_colors.unfocused #000000FF
          dim_inactive_colors.urgent #900000FF

          # Treat Scratchpad as minimized
          scratchpad_minimize disable
        '';

      extraSessionCommands = ''
        export XDG_CURRENT_DESKTOP=sway
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      systemd.enable = true;
    };
  };
}

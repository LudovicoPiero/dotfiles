{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.vars.colorScheme) colors;
in
{
  programs.sway.enable = true; # Enable nixos modules

  home-manager.users.${config.vars.username} = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    home.packages = with pkgs; [
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
      swayidle
      swaylock
      wf-recorder
      wl-clipboard
      wlogout
      slurp
      grim
      swappy
      playerctl
    ];
    wayland.windowManager.sway = {
      enable = true;
      # package = pkgs.swayfx; # Grabbed from overlays/overrides.nix
      config = {
        colors = import ./colors.nix { inherit colors; };
        keybindings = import ./keybindings.nix { inherit config pkgs; };
        bars = import ./bars.nix { inherit colors; };
        window = import ./windows.nix;
        output = {
          "*" = {
            bg = "#2e2b2b solid_color";
          };
          # "*" = {bg = "${./Wallpaper/wallpaper.jpg} fill";};
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
          { command = "systemctl --user stop xdg-desktop-portal-wlr"; }
          { command = "dunst"; }
          {
            command = "systemctl --user restart xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk";
            always = true;
          }
        ];
        modifier = "Mod4";
        terminal = "${config.vars.terminalBin}";
        menu = "${pkgs.fuzzel}/bin/fuzzel";
      };
      extraConfig = ''
        titlebar_border_thickness 1
        title_align center
        titlebar_padding 2

        # # SwayFX stuff
        # # window corner radius in px
        # corner_radius 5
        #
        # shadows off
        # shadows_on_csd off
        # shadow_blur_radius 20
        # shadow_color #0000007F
        #
        # # inactive window fade amount. 0.0 = no dimming, 1.0 = fully dimmed
        # default_dim_inactive 0.0
        # dim_inactive_colors.unfocused #000000FF
        # dim_inactive_colors.urgent #900000FF
        #
        # # Treat Scratchpad as minimized
        # # scratchpad_minimize enable
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

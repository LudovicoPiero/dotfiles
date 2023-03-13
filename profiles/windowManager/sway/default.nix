{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (config.vars.colorScheme) colors;
  sharenix = pkgs.writeShellScriptBin "sharenix" ''${builtins.readFile ./Scripts/screenshot}'';
in {
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
      sharenix
      playerctl
      fuzzel
    ];
    wayland.windowManager.sway = {
      enable = true;
      package = inputs.swayfx.packages.${pkgs.system}.default;
      config = {
        colors = import ./colors.nix {inherit colors;};
        keybindings = import ./keybindings.nix {inherit config pkgs;};
        bars = import ./bars.nix {inherit pkgs colors;};
        window = import ./windows.nix;
        output = {
          "*" = {bg = "#2e2b2b solid_color";};
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
            {window_role = "pop-up";}
            {window_role = "bubble";}
            {window_role = "dialog";}
            {window_type = "dialog";}
            {app_id = "lutris";}
            {app_id = "thunar";}
            {app_id = "pavucontrol";}
            {class = ".*.exe";} # Wine apps
            {class = "steam_app.*";} # Steam games
            {class = "^Steam$";} # Steam itself
          ];
        };
        gaps = {
          inner = 3;
          outer = 3;
        };
        fonts = {
          names = ["Iosevka Comfy"];
          size = 10.0;
        };
        startup = [
          {command = "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";}
          {command = "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP";}
          {command = "dunst";}
          {
            command = "systemctl --user restart xdg-desktop-portal xdg-desktop-portal-wlr";
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

        # SwayFX stuff
        # window corner radius in px
        corner_radius 5

        shadows off
        shadows_on_csd off
        shadow_blur_radius 20
        shadow_color #0000007F

        # inactive window fade amount. 0.0 = no dimming, 1.0 = fully dimmed
        default_dim_inactive 0.0
        dim_inactive_colors.unfocused #000000FF
        dim_inactive_colors.urgent #900000FF
      '';
      extraSessionCommands = ''
        export XDG_CURRENT_DESKTOP=sway
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      wrapperFeatures = {gtk = true;};
      systemdIntegration = false;
    };

    # programs.fish.interactiveShellInit = lib.mkBefore ''
    #   if test -z $DISPLAY && test (tty) = "/dev/tty1"
    #       exec sway
    #   end
    # '';

    xdg.configFile."fuzzel/fuzzel.ini".text = ''
      font='Iosevka Nerd Font-16'
      icon-theme='WhiteSur'
      prompt='->'
      [dmenu]
      mode=text
      [colors]
      background=24283bff
      text=a9b1d6ff
      match=8031caff
      selection=8031caff
      selection-text=7aa2f7ff
      selection-match=2ac3deff
      border=8031caff
      [border]
      width=2
      radius=0
    '';
  };
}

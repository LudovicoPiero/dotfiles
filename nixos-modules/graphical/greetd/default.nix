{
  config,
  lib,
  pkgs,
  username,
  self,
  ...
}:
let
  cfg = config.mine.greetd;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.greetd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable greetd.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc."greetd/environments".text = ''
        Hyprland
        sway
        fish
      '';
    };

    security.pam = {
      services.greetd.gnupg.enable = true;
      services.greetd.enableGnomeKeyring = true;
    };

    programs.regreet = {
      enable = true;
      settings = {
        background = "${self}/assets/Minato-Aqua-Dark.png";
        GTK = {
          cursor_theme_name = "macOS-BigSur";
          font_name = "SF Pro Rounded 16";
          icon_theme_name = "WhiteSur";
          theme_name = "WhiteSur-Dark";
        };
      };
    };

    services.greetd =
      let
        user = username;
        _ = lib.getExe;
        __ = lib.getExe';
      in
      /* sway = "${lib.getExe pkgs.sway}";
         swayConf = pkgs.writeText "greetd-sway-config" ''
           output * background #000000 solid_color
           exec "dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
           xwayland disable

           exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
         '';
      */
      {
        enable = true;
        vt = 7;
        settings = {
          default_session = {
            command = "${__ pkgs.dbus "dbus-run-session"} ${_ pkgs.cage} -s -- ${_ config.programs.regreet.package}";
            inherit user;
          };
        };
      };
  };
}

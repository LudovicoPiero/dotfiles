{
  config,
  lib,
  pkgs,
  username,
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

    services.greetd =
      let
        user = username;
        sway = "${lib.getExe pkgs.sway}";
        swayConf = pkgs.writeText "greetd-sway-config" ''
          output * background #000000 solid_color
          exec "dbus-update-activation-environment --systemd WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
          xwayland disable

          exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
        '';
      in
      {
        enable = true;
        vt = 7;
        settings = {
          default_session = {
            command = "${sway} --config ${swayConf}";
            inherit user;
          };
        };
      };
  };
}

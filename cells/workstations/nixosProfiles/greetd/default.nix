{ pkgs, lib, ... }:
{
  security = {
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.swaylock.text = "auth include login";
  };

  environment = {
    etc."greetd/environments".text = ''
      Hyprland
      sway
      fish
    '';
  };

  services.greetd =
    let
      username = "airi";
      _ = lib.getExe;
    in
    /*
      __ = lib.getExe';

      swayConf = pkgs.writeText "greetd-sway-config" ''
        output * background #000000 solid_color
        exec "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        xwayland disable

        exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
      '';
    */
    {
      enable = true;
      settings = {
        default_session = {
          command = "${_ pkgs.cage} -s -- ${_ pkgs.greetd.gtkgreet} -l";
          # command = "${_ pkgs.sway} --config ${swayConf}";
          user = "${username}";
        };
      };
    };
}

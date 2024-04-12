{ pkgs, lib, ... }:
{
  security = {
    pam.services.greetd.gnupg.enable = true;
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
      __ = lib.getExe';
    in
    {
      enable = true;
      settings = {
        default_session = {
          command = "${__ pkgs.dbus "dbus-run-session"} ${_ pkgs.cage} -s -- ${_ pkgs.greetd.gtkgreet} -l";
          user = "${username}";
        };
      };
    };
}

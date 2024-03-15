{
  config,
  lib,
  pkgs,
  username,
  inputs,
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
      etc."greetd/environments".text =
        let
          inherit (lib.strings) concatStrings optionalString;
          inherit (inputs.self.homeConfigurations."airi@sforza".config) mine;
        in
        concatStrings [
          (optionalString mine.hyprland.enable "Hyprland\n")
          (optionalString mine.sway.enable "sway\n")
        ];
    };

    security.pam = {
      services.greetd.gnupg.enable = true;
      services.greetd.enableGnomeKeyring = true;
    };

    services.greetd =
      let
        user = username;
        _ = lib.getExe;
        __ = lib.getExe';
      in
      {
        enable = true;
        vt = 7;
        settings = {
          default_session = {
            command = "${__ pkgs.dbus "dbus-run-session"} ${_ pkgs.cage} -s -- ${_ pkgs.greetd.gtkgreet} -l";
            inherit user;
          };
        };
      };
  };
}

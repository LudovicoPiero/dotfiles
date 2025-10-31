{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.gpg;
  guiCfg = config.vars.withGui;
in
{
  options.mine.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.gcr ];

    environment.sessionVariables = {
      GNUPGHOME = "/home/${config.vars.username}/.config/gnupg";
    };

    programs.gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = if guiCfg then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
      };
    };
  };
}

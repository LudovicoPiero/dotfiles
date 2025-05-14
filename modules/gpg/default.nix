{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.myOptions.gpg;
  guiCfg = config.vars.withGui;
in
{
  options.myOptions.gpg = {
    enable = mkEnableOption "gpg" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [
      pkgs.gcr
    ];

    hj.environment.sessionVariables = {
      GNUPGHOME = "${config.vars.homeDirectory}/.config/gnupg";
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

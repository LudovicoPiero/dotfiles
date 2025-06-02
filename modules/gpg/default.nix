{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  guiCfg = config.vars.withGui;

  cfg = config.mine.gpg;
in
{
  options.mine.gpg = {
    enable = mkEnableOption "gpg";
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.gcr ];

    hm =
      { config, ... }:
      {
        programs.gpg = {
          enable = true;
          homedir = "${config.xdg.configHome}/gnupg";
        };

        # Fix pass
        services.gpg-agent = {
          enable = true;
          pinentry.package = if guiCfg then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
          extraConfig = ''
            allow-emacs-pinentry
            allow-loopback-pinentry
            allow-preset-passphrase
          '';
        };
      };
  };
}

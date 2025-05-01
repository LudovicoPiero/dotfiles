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
    services.dbus.packages = [ pkgs.gcr ];

    home-manager.users.${config.vars.username} =
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

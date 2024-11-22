{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.gpg;
in {
  options.myOptions.gpg = {
    enable =
      mkEnableOption "gpg"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [pkgs.gcr];

    home-manager.users.${config.myOptions.vars.username} = {config, ...}: {
      programs.gpg = {
        enable = true;
        homedir = "${config.xdg.configHome}/gnupg";
      };

      # Fix pass
      services.gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gnome3;
        extraConfig = ''
          allow-emacs-pinentry
          allow-loopback-pinentry
          allow-preset-passphrase
        '';
      };
    };
  };
}

{
  config,
  pkgs,
  ...
}: {
  /*
  Beware that pinentry-gnome3 may not work on non-Gnome
  systems.
  */
  services.dbus.packages = [pkgs.gcr];

  home-manager.users."${config.vars.username}" = {
    programs.gpg = {
      enable = true;
      homedir = "${config.vars.configHome}/gnupg";
    };

    # Fix pass
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
      extraConfig = ''
        allow-emacs-pinentry
        allow-preset-passphrase
      '';
    };
  };
}

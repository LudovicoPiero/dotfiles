{config, ...}: {
  home-manager.users."${config.vars.username}" = {
    programs.gpg = {
      enable = true;
      homedir = "${config.vars.configHome}/gnupg";
    };

    # Fix pass
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
  };
}

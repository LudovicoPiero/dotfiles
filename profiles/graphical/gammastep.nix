{config, ...}: {
  # Location service
  location.provider = "geoclue2";
  services = {
    geoclue2 = {
      enable = true;
      appConfig.gammastep = {
        isAllowed = true;
        isSystem = false;
      };
    };
  };

  home-manager.users."${config.vars.username}" = {
    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      tray = true;
    };
  };
}

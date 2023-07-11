{config, ...}: {
  home-manager.users."${config.vars.username}" = {
    services.wlsunset = {
      enable = true;
      latitude = "-37";
      longitude = "144";
    };
  };
}

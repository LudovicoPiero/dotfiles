{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username}.programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: {
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs;
    with jetbrains; [
      goland
      clion
    ];
  };
}

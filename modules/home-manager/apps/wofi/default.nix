{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.wofi];

  xdg.configFile = {
    "wofi" = {
      source = ./.;
      recursive = true;
    };
  };
}

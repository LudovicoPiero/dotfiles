{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "rei" ])
  ];

  home-manager.users.rei = {
    home = {
      username = "rei";
      homeDirectory = "/home/rei";
      preferXdgDirectories = true;
      stateVersion = "26.05";
    };
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  system.stateVersion = "26.05";
}

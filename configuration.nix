{ lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./modules
    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" "rei" ])
  ];

  home-manager.users.rei = _: {
    home = {
      username = "rei";
      homeDirectory = "/home/rei";

      stateVersion = "26.05";
    };

    # Manage standard user folders automatically
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  system.stateVersion = "26.05";
}

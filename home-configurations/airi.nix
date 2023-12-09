{ username, ... }: {
  home = {
    inherit username;
    homeDirectory = "/home/airi";

    stateVersion = "23.11";
  };

  mine = {
    git.enable = true;
    gpg.enable = true;
    fish.enable = true;
  };
}

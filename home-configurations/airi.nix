{username, ...}: {
  home = {
    inherit username;
    homeDirectory = "/home/airi";

    stateVersion = "23.11";
  };

  mine = {
    hyprland.enable = true;
    gammastep.enable = true;
    git.enable = true;
    gpg.enable = true;
    zsh.enable = true;
  };
}

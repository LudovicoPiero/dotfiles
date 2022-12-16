{pkgs, ...}: {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  # i use hyprland to execute the daemon
  # services.emacs = {
  #   enable = true;
  #   defaultEditor = true; # it will override $EDITOR
  # };
}

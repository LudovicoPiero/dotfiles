{pkgs, ...}: {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  services.emacs = {
    enable = true;
  };
}

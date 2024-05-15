#        ████  ████
#      ██    ██    ██
#        ██    ██  ██
#          ██████████
#        ████░░██░░░░██
#      ██░░██░░██░░░░░░▓▓
#  ▓▓▓▓██░░██░░██░░▓▓░░██
#      ██░░██░░██░░░░░░██
#        ████░░██░░░░██
#          ██████████
{ inputs, cell }:
{
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs-unstable {
    inherit (inputs.nixpkgs) system;
    config.allowUnfree = true;
    config.allowBroken = true;
    overlays = [
      inputs.emacs-overlay.overlays.default
      inputs.lix-module.overlays.default
    ];
  };
  home = inputs.home-manager;
}

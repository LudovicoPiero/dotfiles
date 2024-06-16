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
  pkgs = import inputs.nixpkgs {
    inherit (inputs.nixpkgs) system;
    config.allowUnfree = true;
    config.allowBroken = true;
    overlays = [
      inputs.lix-module.overlays.default
      inputs.emacs-overlay.overlays.default
    ];
  };
  home = inputs.home-manager;
}

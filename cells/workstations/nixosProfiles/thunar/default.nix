{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  environment.systemPackages = [ nixpkgs.xfce.thunar ];

  programs.thunar.plugins = with nixpkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}

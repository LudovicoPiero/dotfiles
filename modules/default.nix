{ lib, ... }:
{
  imports = [
    ./fish
    ./firefox

    ./shared.nix
    ./vars.nix
    ./fonts.nix
    ./git.nix
    ./gpg.nix
  ];
}

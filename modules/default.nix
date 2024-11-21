{ lib, ... }:
{
  imports = [
    ./fish
    ./firefox

    ./shared.nix
    ./vars.nix
    ./git.nix
    ./gpg.nix
  ];
}

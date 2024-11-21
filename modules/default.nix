{ lib, ... }:
{
  imports = [
    ./fish
    ./firefox

    ./shared.nix
    ./vars.nix
    ./theme.nix
    ./fonts.nix
    ./git.nix
    ./gpg.nix
  ];
}

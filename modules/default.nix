{ lib, ... }:
{
  imports = [
    ./fish
    ./firefox
    ./hyprland
    ./waybar

    ./shared.nix
    ./vars.nix
    ./mako.nix
    ./theme.nix
    ./wezterm.nix
    ./keyring.nix
    ./xdg-portal.nix
    ./fonts.nix
    ./git.nix
    ./gpg.nix
    ./nvim.nix
  ];
}

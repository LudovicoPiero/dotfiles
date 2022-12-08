{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    inputs.nil.packages.${pkgs.system}.default
  ];
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # use vscode because copilot no worky :(
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      kamadorueda.alejandra
      kamikillerto.vscode-colorize # css background
      catppuccin.catppuccin-vsc # Color theme
      github.copilot
      pkief.material-icon-theme
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss
    ];
  };
}

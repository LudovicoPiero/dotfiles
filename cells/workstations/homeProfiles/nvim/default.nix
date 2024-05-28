{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home = {
    packages = [ inputs.nvim-flake.packages.${pkgs.system}.default ];
  };

  programs.fish.shellAliases = {
    v = "nvim";
  };
}

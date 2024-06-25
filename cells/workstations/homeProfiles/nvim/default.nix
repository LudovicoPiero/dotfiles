{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.ludovico-nixvim.packages.${pkgs.system}.nvim ];
  programs.fish.shellAliases = {
    v = "nvim";
  };
}

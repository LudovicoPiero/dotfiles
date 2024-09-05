{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.ludovico-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.nvim ];
  programs.fish.shellAliases = {
    v = "nvim";
  };
}

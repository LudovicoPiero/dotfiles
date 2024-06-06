{
  pkgs,
  lib,
  inputs,
  ...
}:
{

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./__config
  ];

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    luaLoader.enable = true; # Experimental lua loader
  };

  programs.fish.shellAliases = {
    v = "nvim";
  };
}

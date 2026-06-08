{ lib, pkgs, ... }:
{
  options.mine.nvim = {
    enable = lib.mkEnableOption "Neovim";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.neovim;
      description = "The Neovim package to use.";
    };
  };
}

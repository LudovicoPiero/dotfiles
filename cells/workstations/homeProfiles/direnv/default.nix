{ pkgs, osConfig, ... }:
{
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv.override { nix = osConfig.nix.package; };
    };
  };
}

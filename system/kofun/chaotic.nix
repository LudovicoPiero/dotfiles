{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.chaotic.nixosModules.default ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-lto;

  chaotic = {
    mesa-git.enable = true;
  };

  # Steam
  programs.steam.extraCompatPackages = lib.mkIf config.mine.games.steam.enable [
    pkgs.proton-ge-custom
  ];
}

{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "unit01";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Jakarta";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}

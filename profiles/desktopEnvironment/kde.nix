{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ xclip ];
  services.xserver.desktopManager.plasma5.enable = true;
  services.power-profiles-daemon.enable = lib.mkForce false;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    plasma-browser-integration
    print-manager
  ];
}

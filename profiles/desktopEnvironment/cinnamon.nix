{ pkgs, lib, ... }:
{
  hardware.pulseaudio.enable = lib.mkForce false;
  qt = {
    platformTheme = lib.mkForce "gtk2";
    style = lib.mkForce "gtk2";
  };
  environment.systemPackages = with pkgs; [ xclip ];
  services.xserver.desktopManager.cinnamon = {
    enable = true;
    sessionPath = with pkgs; [ gnome.gpaste ]; # clipboard manager
  };
}

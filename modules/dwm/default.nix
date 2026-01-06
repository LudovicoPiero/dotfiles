{
  config,
  lib,
  pkgs,
  inputs,
  inputs',
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.dwm;
  suckless = inputs'.suckless.packages;
in
{
  imports = [
    inputs.xlibre-overlay.nixosModules.overlay-xlibre-xserver
    # inputs.xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
    inputs.xlibre-overlay.nixosModules.overlay-xlibre-xf86-input-evdev
    inputs.xlibre-overlay.nixosModules.overlay-xlibre-xf86-video-fbdev
    inputs.xlibre-overlay.nixosModules.overlay-xlibre-xf86-input-libinput
    inputs.xlibre-overlay.nixosModules.overlay-xlibre-xf86-video-amdgpu
  ];
  options.mine.dwm = {
    enable = mkEnableOption "dwm window manager";
  };

  config = mkIf cfg.enable {
    programs.slock.enable = true;

    services = {
      xserver = {
        enable = true;
        autoRepeatDelay = 300;
        autoRepeatInterval = 33; # ~30 repeats per second

        windowManager.dwm = {
          enable = true;
          package = suckless.dwm;
        };

        displayManager.sessionCommands = ''
          # Hardware Setup
          ${lib.getExe pkgs.xorg.xrandr} --output HDMI-A-1 --mode 1920x1080 --rate 180.00 --output eDP-1 --off

          # Backgrounds & Compositor
          ${lib.getExe pkgs.feh} --bg-scale "$HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png" &

          # Core Services
          ${lib.getExe suckless.dwmblocks-async} &
          ${lib.getExe pkgs.dunst} &
          ${lib.getExe pkgs.fcitx5} -d --replace &
          ${lib.getExe' pkgs.clipmenu "clipmenud"} &

          # Security
          ${lib.getExe pkgs.xautolock} -time 10 -locker slock &
        '';
      };
    };

    environment.systemPackages = [
      suckless.dmenu
      suckless.st
      suckless.dwmblocks-async
      pkgs.tabbed

      # X11 Utils
      pkgs.xorg.xrandr
      pkgs.xorg.xset
      pkgs.xorg.xprop
      pkgs.feh
      pkgs.dunst
      pkgs.xclip
      pkgs.xautolock
      pkgs.clipmenu
    ];
  };
}

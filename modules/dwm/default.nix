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
          # Disable default X11 blanking so xautolock manages it exclusively
          ${lib.getExe pkgs.xorg.xset} s off -dpms

          # Set monitor layout
          ${lib.getExe pkgs.xorg.xrandr} --output HDMI-1 --mode 1920x1080 --rate 180.00 --primary --output eDP-1 --off

          # Polkit Authentication Agent
          ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &

          # Restore wallpaper
          ${lib.getExe pkgs.feh} --bg-scale "$HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png" &

          # Picom
          ${lib.getExe pkgs.picom} -b &

          # Core Services
          ${lib.getExe suckless.dwmblocks-async} &
          ${lib.getExe pkgs.dunst} &

          # Input Method
          export QT_IM_MODULE=fcitx
          export XMODIFIERS=@im=fcitx
          ${lib.getExe pkgs.fcitx5} -d --replace &

          # Bluetooth Applet
          ${lib.getExe' pkgs.blueman "blueman-applet"} &

          # Clipboard
          ${lib.getExe' pkgs.clipmenu "clipmenud"} &

          # Lock after 10 mins, sleep after 20 mins (optional systemctl command)
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

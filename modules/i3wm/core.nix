{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mine.i3;
  c = config.mine.theme.colors;
in
{
  options.mine.i3 = {
    enable = mkEnableOption "i3 window manager";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.i3.enable = true;
    };

    environment.systemPackages = with pkgs; [
      feh
      dunst
      i3status
      brightnessctl
      wireplumber
      libnotify
      polkit_gnome
      rofi
      maim
      xclip
      haskellPackages.greenclip
      tesseract
      xset
      setxkbmap
      xrandr
      flameshot
    ];

    hj.xdg.config.files."i3/config".text = ''
      set $mod Mod4
      font pango:monospace 10

      gaps inner 2
      gaps outer 2
      smart_gaps on

      default_border pixel 2
      default_floating_border pixel 2
      floating_modifier $mod

      client.focused ${c.base0D} ${c.base0D} ${c.base05} ${c.base0D} ${c.base0D}
      client.unfocused ${c.base02} ${c.base02} ${c.base05} ${c.base02} ${c.base02}
      client.focused_inactive ${c.base02} ${c.base02} ${c.base05} ${c.base02} ${c.base02}

      exec --no-startup-id xrandr --output HDMI-A-1 --mode 1920x1080 --rate 180 --primary --output eDP-1 --off
      exec --no-startup-id setxkbmap -layout us -option ctrl:nocaps
      exec --no-startup-id xset r rate 300 30
      exec --no-startup-id fcitx5 -d --replace
      exec --no-startup-id feh --bg-fill $HOME/Pictures/Wallpaper/Minato-Aqua-Dark.png
      exec --no-startup-id dunst
      exec --no-startup-id emacs --daemon
      exec --no-startup-id greenclip daemon
      exec --no-startup-id i3-msg 'workspace 5; exec thunderbird; workspace 1'

      bar {
          status_command i3status
          colors {
              background ${c.base00}
              statusline ${c.base05}
              focused_workspace ${c.base0D} ${c.base0D} ${c.base00}
              active_workspace ${c.base02} ${c.base02} ${c.base05}
              inactive_workspace ${c.base00} ${c.base00} ${c.base05}
              urgent_workspace ${c.base08} ${c.base08} ${c.base05}
          }
      }

      include ~/.config/i3/config.d/*
    '';
  };
}

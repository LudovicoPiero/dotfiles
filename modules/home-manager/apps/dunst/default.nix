{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.libnotify];
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
      size = "32x32";
    };
    settings = {
      global = {
        width = 300;
        height = 100;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#89B4FA"; # border
        font = "JetBrains Mono Nerd Font 10";
        notification_limit = 5;
        layer = "overlay"; # bottom, top or overlay
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        corner_radius = 6;
      };
      urgency_low = {
        frame_color = "#2D3039";
        timeout = 3;
      };
      urgency_normal = {
        frame_color = "#89DCEB";
        timeout = 5;
      };
      urgency_critical = {
        frame_color = "#FAB387";
        timeout = 8;
      };
    };
  };
}

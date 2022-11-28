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
        frame_color = "#1E1E2E";
        font = "JetBrains Mono Nerd Font 10";
        notification_limit = 5;
        layer = "overlay"; # bottom, top or overlay
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        corner_radius = 6;
      };
    };
  };
}

{
  pkgs,
  config,
  ...
}: let
  inherit (config.colorScheme) colors;
in {
  home.packages = [pkgs.libnotify];
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "BeautyLine";
      package = pkgs.beauty-line-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        width = 300;
        height = 100;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        background = "#${colors.base00}";
        frame_color = "#${colors.base06}"; # border
        font = "Iosevka q 10";
        notification_limit = 5;
        layer = "overlay"; # bottom, top or overlay
        fullscreen = "pushback";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        corner_radius = 6;
      };
      urgency_low = {
        background = "#${colors.base00}";
        foreground = "#${colors.base05}";
        timeout = 3;
      };
      urgency_normal = {
        background = "#${colors.base00}";
        foreground = "#${colors.base06}";
        timeout = 5;
      };
      urgency_critical = {
        foreground = "#${colors.base0D}";
        frame_color = "#${colors.base08}";
        timeout = 8;
      };
    };
  };
}

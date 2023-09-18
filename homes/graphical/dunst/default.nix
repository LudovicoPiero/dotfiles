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
        transparency = 20;
        background = "#${colors.base00}";
        frame_color = "#${colors.base05}"; # border
        separator_color = "#${colors.base02}";
        font = "JetBrains Mono 10";
        notification_limit = 5;
        layer = "overlay"; # bottom, top or overlay
        fullscreen = "pushback";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        corner_radius = 6;
      };
      urgency_low = {
        background = "#${colors.base01}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base0B}";
        timeout = 3;
      };
      urgency_normal = {
        background = "#${colors.base01}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base0B}";
        timeout = 5;
      };
      urgency_critical = {
        background = "#${colors.base01}";
        foreground = "#${colors.base05}";
        frame_color = "#${colors.base0B}";
        timeout = 8;
      };
    };
  };
}

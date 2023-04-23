{colorscheme}:
with colorscheme.colors; {
  global = {
    width = 300;
    height = 100;
    offset = "30x50";
    origin = "top-right";
    transparency = 10;
    background = "#${colors.base00}";
    frame_color = "#${colors.base06}"; # border
    font = "Iosevka Nerd Font 10";
    notification_limit = 5;
    layer = "overlay"; # bottom, top or overlay
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
}

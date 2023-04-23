{colorscheme}:
with colorscheme.colors; {
  global = {
    width = 300;
    height = 100;
    offset = "30x50";
    origin = "top-right";
    transparency = 10;
    background = "#${base00}";
    frame_color = "#${base06}"; # border
    font = "Iosevka Nerd Font 10";
    notification_limit = 5;
    layer = "overlay"; # bottom, top or overlay
    browser = "xdg-open";
    corner_radius = 6;
  };
  urgency_low = {
    background = "#${base00}";
    foreground = "#${base05}";
    timeout = 3;
  };
  urgency_normal = {
    background = "#${base00}";
    foreground = "#${base06}";
    timeout = 5;
  };
  urgency_critical = {
    foreground = "#${base0D}";
    frame_color = "#${base08}";
    timeout = 8;
  };
}

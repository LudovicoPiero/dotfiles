{
  lib,
  config,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  background = "#${colors.base00}";
  focused = {
    # <colorclass> <border> <background> <text> <indicator> <child_border>
    background = "#${colors.base0D}";
    border = "#${colors.base05}";
    text = "#${colors.base00}";
    indicator = "#${colors.base0D}";
    childBorder = "#${colors.base0D}";
  };
  focusedInactive = {
    background = "#${colors.base0D}";
    border = "#${colors.base01}";
    text = "#${colors.base05}";
    childBorder = "#${colors.base01}";
    indicator = "#${colors.base03}";
  };
  placeholder = {
    background = "#${colors.base0D}";
    border = "#${colors.base00}";
    text = "#${colors.base05}";
    childBorder = "#${colors.base00}";
    indicator = "#${colors.base00}";
  };
  unfocused = {
    background = "#${colors.base00}";
    border = "#${colors.base01}";
    text = "#${colors.base05}";
    childBorder = "#${colors.base01}";
    indicator = "#${colors.base01}";
  };
  urgent = {
    background = "#${colors.base08}";
    border = "#${colors.base08}";
    text = "#${colors.base00}";
    childBorder = "#${colors.base08}";
    indicator = "#${colors.base08}";
  };
}

{ colors, ... }:
{
  background = "#${colors.base00}";
  focused = {
    background = "#${colors.base0E}";
    border = "#${colors.base05}";
    childBorder = "#${colors.base0E}";
    indicator = "#${colors.base0E}";
    text = "#${colors.base00}";
  };
  focusedInactive = {
    background = "#${colors.base01}";
    border = "#${colors.base01}";
    childBorder = "#${colors.base01}";
    indicator = "#${colors.base03}";
    text = "#${colors.base05}";
  };
  placeholder = {
    background = "#${colors.base00}";
    border = "#${colors.base00}";
    childBorder = "#${colors.base00}";
    indicator = "#${colors.base00}";
    text = "#${colors.base05}";
  };
  unfocused = {
    background = "#${colors.base00}";
    border = "#${colors.base01}";
    childBorder = "#${colors.base01}";
    indicator = "#${colors.base01}";
    text = "#${colors.base05}";
  };
  urgent = {
    background = "#${colors.base0A}";
    border = "#${colors.base0A}";
    childBorder = "#${colors.base0A}";
    indicator = "#${colors.base0A}";
    text = "#${colors.base00}";
  };
}

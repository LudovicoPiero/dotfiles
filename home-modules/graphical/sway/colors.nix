{palette, ...}: {
  background = "#${palette.base00}";
  focused = {
    background = "#${palette.base0E}";
    border = "#${palette.base05}";
    childBorder = "#${palette.base0E}";
    indicator = "#${palette.base0E}";
    text = "#${palette.base00}";
  };
  focusedInactive = {
    background = "#${palette.base01}";
    border = "#${palette.base01}";
    childBorder = "#${palette.base01}";
    indicator = "#${palette.base03}";
    text = "#${palette.base05}";
  };
  placeholder = {
    background = "#${palette.base00}";
    border = "#${palette.base00}";
    childBorder = "#${palette.base00}";
    indicator = "#${palette.base00}";
    text = "#${palette.base05}";
  };
  unfocused = {
    background = "#${palette.base00}";
    border = "#${palette.base01}";
    childBorder = "#${palette.base01}";
    indicator = "#${palette.base01}";
    text = "#${palette.base05}";
  };
  urgent = {
    background = "#${palette.base0A}";
    border = "#${palette.base0A}";
    childBorder = "#${palette.base0A}";
    indicator = "#${palette.base0A}";
    text = "#${palette.base00}";
  };
}

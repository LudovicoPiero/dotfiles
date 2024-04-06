{ palette, ... }:
{
  background = "#${palette.base00}";
  focused = {
    background = "#${palette.base0D}";
    border = "#${palette.base05}";
    childBorder = "#${palette.base0D}";
    indicator = "#${palette.base0D}";
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
    background = "#${palette.base08}";
    border = "#${palette.base08}";
    childBorder = "#${palette.base08}";
    indicator = "#${palette.base08}";
    text = "#${palette.base00}";
  };
}

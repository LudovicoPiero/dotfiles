{
  config,
  colorscheme,
}:
with colorscheme.colors; {
  main = {
    font = "Iosevka Nerd Font-16";
    icon-theme = "${config.gtk.iconTheme.name}";
    prompt = "->";
  };

  border = {
    width = 2;
    radius = 0;
  };

  dmenu = {
    mode = "text";
  };

  colors = {
    background = "${base00}ff";
    text = "${base07}ff";
    match = "${base0E}ff";
    selection = "${base08}ff";
    selection-text = "${base07}ff";
    selection-match = "${base07}ff";
    border = "${base0E}ff";
  };
}

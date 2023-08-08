{config, ...}: {
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = config.gtk.theme.name;
  };
}

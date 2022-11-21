{ pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10;
    };
    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors-white";
      size = 24;
    };
    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };
}

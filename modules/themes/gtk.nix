{ pkgs, ... }: {
  programs.dconf.enable = true;

  hm = {
    gtk = {
      enable = true;
      colorScheme = "dark";

      font = {
        name = "Inter";
        package = pkgs.inter;
      };

      theme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };

      iconTheme = {
        name = "WhiteSur-dark";
        package = pkgs.whitesur-icon-theme;
      };

      cursorTheme = {
        name = "phinger-cursors-light";
        package = pkgs.phinger-cursors;
        size = 24;
      };
    };
  };
}

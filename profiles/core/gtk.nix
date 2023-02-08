{
  config,
  pkgs,
  ...
}: {
  home-manager.users."${config.vars.username}" = {
    gtk = {
      enable = true;

      gtk2 = {
        configLocation = "${config.vars.configHome}/gtk-2.0/gtkrc";
      };

      font = {
        name = "Google Sans";
        size = 10;
      };

      theme = {
        package = pkgs.whitesur-gtk-theme;
        name = "WhiteSur-Dark";
      };

      cursorTheme = {
        package = pkgs.capitaine-cursors;
        name = "capitaine-cursors-white";
        size = 24;
      };

      iconTheme = {
        package = pkgs.whitesur-icon-theme;
        name = "WhiteSur";
      };
    };
  };
}

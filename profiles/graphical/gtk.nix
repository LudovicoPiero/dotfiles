{
  config,
  pkgs,
  ...
}: let
  font = {
    name = "SF Pro Rounded";
    size = 11;
  };
  theme = {
    name = "WhiteSur-Dark";
    package = pkgs.whitesur-gtk-theme;
  };
  cursorTheme = {
    name = "capitaine-cursors-white";
    size = 24;
    package = pkgs.capitaine-cursors;
  };
  iconsTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
in {
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [capitaine-cursors];
    gtk = {
      #TODO: change to true if not using any DEs
      enable = true;
      gtk2.extraConfig = ''
        gtk-cursor-theme-name="${cursorTheme.name}"
        gtk-cursor-theme-size="${builtins.toString cursorTheme.size}"
      '';
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-cursor-theme-name = cursorTheme.name;
      };
      font = {
        inherit (font) name size;
      };
      theme = {
        inherit (theme) name package;
      };
      iconTheme = {
        inherit (iconsTheme) name package;
      };
    };

    home.file.".icons/default/index.theme".text = ''
      [icon theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${cursorTheme.name}
    '';

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = theme.name;
        icon-theme = iconsTheme.name;
        cursor-theme = cursorTheme.name;
      };
    };
  };
}

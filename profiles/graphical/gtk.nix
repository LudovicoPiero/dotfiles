{
  config,
  pkgs,
  ...
}: let
  font = {
    name = "Google Sans";
    size = 10;
  };
  theme = {
    name = "WhiteSur-Dark";
    package = pkgs.whitesur-gtk-theme;
  };
  cursorsTheme = {
    name = "capitaine-cursors-white";
    size = 24;
    package = pkgs.capitaine-cursors;
  };
  iconsTheme = {
    name = "WhiteSur";
    package = pkgs.whitesur-icon-theme;
  };
in {
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [capitaine-cursors];
    gtk = {
      enable = true;
      gtk2.extraConfig = ''
        gtk-cursor-theme-name="${cursorsTheme.name}"
        gtk-cursor-theme-size="${builtins.toString cursorsTheme.size}"
      '';
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-cursor-theme-name = cursorsTheme.name;
      };
      font = {
        inherit (font) name;
        inherit (font) size;
      };
      theme = {
        inherit (theme) package;
        inherit (theme) name;
      };
      iconTheme = {
        inherit (iconsTheme) package;
        inherit (iconsTheme) name;
      };
    };

    home.file.".icons/default/index.theme".text = ''
      [icon theme]
      Name=Default
      Comment=Default Cursor Theme
      Inherits=${cursorsTheme.name}
    '';

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = theme.name;
        icon-theme = iconsTheme.name;
        cursor-theme = cursorsTheme.name;
      };
    };
  };
}

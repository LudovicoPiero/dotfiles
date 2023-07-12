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
    name = "Arc-Dark";
    package = pkgs.arc-theme;
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
      enable = true;
      gtk2.extraConfig = ''
        gtk-cursor-theme-name="${cursorTheme.name}"
        gtk-cursor-theme-size=${toString cursorTheme.size}
        gtk-toolbar-style=GTK_TOOLBAR_BOTH
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
      gtk3 = {
        bookmarks = let
          username = config.vars.username;
        in [
          "file:///home/${username}/Code"
          "file:///home/${username}/Documents"
          "file:///home/${username}/Downloads"
          "file:///home/${username}/Games"
          "file:///home/${username}/Music"
          "file:///home/${username}/Pictures"
          "file:///home/${username}/Videos"
          "file:///Stuff"
        ];
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
          gtk-cursor-theme-name = cursorTheme.name;
          gtk-cursor-theme-size = cursorTheme.size;
          gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          gtk-button-images = 1;
          gtk-menu-images = 1;
          gtk-enable-event-sounds = 1;
          gtk-enable-input-feedback-sounds = 1;
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintslight";
          gtk-xft-rgba = "rgb";
        };
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

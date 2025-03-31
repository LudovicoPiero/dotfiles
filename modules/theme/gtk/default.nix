{
  config,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = osConfig.myOptions.theme;
in
{
  gtk = {
    enable = true;
    inherit (cfg) font;
    inherit (cfg.gtk) cursorTheme theme iconTheme;

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-cursor-theme-name="${config.gtk.cursorTheme.name}"
        gtk-cursor-theme-size=${toString config.gtk.cursorTheme.size}
        gtk-toolbar-style=GTK_TOOLBAR_BOTH
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintfull"
        gtk-xft-rgba="rgb"
      '';
    };

    gtk3 = {
      bookmarks = [
        "file://${config.home.homeDirectory}/Code"
        "file://${config.home.homeDirectory}/Media"
        "file://${config.home.homeDirectory}/Documents"
        "file://${config.home.homeDirectory}/Downloads"
        # "file://${config.home.homeDirectory}/Games"
        "file://${config.home.homeDirectory}/Music"
        "file://${config.home.homeDirectory}/Pictures"
        "file://${config.home.homeDirectory}/Videos"
        "file://${config.home.homeDirectory}/WinE"
      ];

      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-cursor-theme-name = config.gtk.cursorTheme.name;
        gtk-cursor-theme-size = config.gtk.cursorTheme.size;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
      };
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  xdg = {
    configFile = {
      "gtk-4.0/assets".source = ./assets;
      "gtk-4.0/gtk.css".source = ./gtk.css;
      "gtk-4.0/gtk-dark.css".source = ./gtk.css;
    };

    systemDirs.data = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    ];
  };
}

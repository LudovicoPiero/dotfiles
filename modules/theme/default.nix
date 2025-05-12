{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.myOptions.theme;
in
{
  imports = [ ./qt.nix ];
  options.myOptions.theme = {
    enable = mkEnableOption "" // {
      default = config.vars.withGui;
    };

    colorScheme = mkOption {
      type = types.anything;
      default = inputs.nix-colors.colorSchemes.${config.vars.colorScheme};
    };

    gtk = {
      cursorTheme = {
        name = mkOption {
          type = types.str;
          default = "phinger-cursors-light";
        };
        size = mkOption {
          type = types.int;
          default = 24;
        };
        package = mkOption {
          type = types.package;
          default = pkgs.phinger-cursors;
        };
      };

      theme = {
        name = mkOption {
          type = types.str;
          default = "Fluent-Dark";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.fluent-gtk-theme;
        };
      };

      iconTheme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur-dark";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.whitesur-icon-theme;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hj = {
      rum.misc.gtk = {
        enable = true;
        packages = [
          cfg.gtk.theme.package
          cfg.gtk.iconTheme.package
          cfg.gtk.cursorTheme.package
        ];

        settings = {
          application-prefer-dark-theme = true;
          enable-animations = true;
          theme-name = cfg.gtk.theme.name;
          font-name = config.myOptions.fonts.main.name;
          cursor-theme = cfg.gtk.cursorTheme.name;
          cursor-size = cfg.gtk.cursorTheme.size;
          cursor-theme-name = cfg.gtk.cursorTheme.name;
          cursor-theme-size = cfg.gtk.cursorTheme.size;
          toolbar-style = "GTK_TOOLBAR_BOTH";
          toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          button-images = 1;
          menu-images = 1;
          enable-event-sounds = 1;
          enable-input-feedback-sounds = 1;
          xft-antialias = 1;
          xft-hinting = 1;
          xft-hintstyle = "hintfull";
          xft-rgba = "rgb";
        };

        bookmarks = [
          "file:///home/${config.vars.username}/Code"
          "file:///home/${config.vars.username}/Media"
          "file:///home/${config.vars.username}/Documents"
          "file:///home/${config.vars.username}/Downloads"
          "file:///home/${config.vars.username}/Games"
          "file:///home/${config.vars.username}/Music"
          "file:///home/${config.vars.username}/Pictures"
          "file:///home/${config.vars.username}/Videos"
          "file:///home/${config.vars.username}/WinE"
        ];
      };

      files = {
        ".local/share/icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cfg.gtk.cursorTheme.name}
        '';
        ".local/share/icons/${cfg.gtk.cursorTheme.name}".source =
          "${cfg.gtk.cursorTheme.package}/share/icons/${cfg.gtk.cursorTheme.name}";

        /*
          NOTE:
          add $HOME/.icons for backward compatibility
          https://specifications.freedesktop.org/icon-theme-spec/latest/#directory_layout
        */
        ".icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cfg.gtk.cursorTheme.name}
        '';
        ".icons/${cfg.gtk.cursorTheme.name}".source =
          "${cfg.gtk.cursorTheme.package}/share/icons/${cfg.gtk.cursorTheme.name}";

        #GTK 3
        ".config/gtk-3.0/assets".source =
          "${cfg.gtk.theme.package}/share/themes/${cfg.gtk.theme.name}/gtk-3.0/assets";
        ".config/gtk-3.0/gtk.css".source =
          "${cfg.gtk.theme.package}/share/themes/${cfg.gtk.theme.name}/gtk-3.0/gtk.css";
        ".config/gtk-3.0/gtk-dark.css".source =
          "${cfg.gtk.theme.package}/share/themes/${cfg.gtk.theme.name}/gtk-3.0/gtk-dark.css";

        # GTK 4
        ".config/gtk-4.0/assets".source =
          "${cfg.gtk.theme.package}/share/themes/${cfg.gtk.theme.name}/gtk-4.0/assets";
        ".config/gtk-4.0/gtk.css".source =
          "${cfg.gtk.theme.package}/share/themes/${cfg.gtk.theme.name}/gtk-4.0/gtk.css";
        ".config/gtk-4.0/gtk-dark.css".source =
          "${cfg.gtk.theme.package}/share/themes/${cfg.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      };
    };
  };
}

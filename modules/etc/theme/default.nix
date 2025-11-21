{ lib, pkgs, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.mine.theme = {
    gtk = {
      theme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur-Dark";
          description = "Name of the GTK theme.";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.whitesur-gtk-theme;
          description = "The GTK theme package.";
        };
      };

      iconTheme = {
        name = mkOption {
          type = types.str;
          default = "WhiteSur";
          description = "Name of the icon theme.";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.whitesur-icon-theme;
          description = "The icon theme package.";
        };
      };
    };

    cursor = {
      name = mkOption {
        type = types.str;
        default = "Phinger Cursors";
        description = "Name of the cursor theme.";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.phinger-cursors;
        description = "The cursor theme package.";
      };
      size = mkOption {
        type = types.int;
        default = 24;
        description = "The size of the cursor.";
      };
    };
  };
}

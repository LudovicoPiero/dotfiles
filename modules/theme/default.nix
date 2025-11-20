{
  lib,
  pkgs,
  self',
  ...
}:

let
  inherit (lib) mkOption types;
in
{
  options.mine.theme = {
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
    iconTheme = mkOption {
      type = types.str;
      default = "WhiteSur";
      description = "Name of the icon theme.";
    };
    iconPackage = mkOption {
      type = types.package;
      default = pkgs.whitesur-icon-theme;
      description = "The icon theme package.";
    };
    cursorTheme = mkOption {
      type = types.str;
      default = "Phinger Cursors";
      description = "Name of the cursor theme.";
    };
    cursorPackage = mkOption {
      type = types.package;
      default = pkgs.phinger-cursors;
      description = "The cursor theme package.";
    };
    font = mkOption {
      type = types.str;
      default = "SF Pro Display 11";
      description = "GTK font.";
    };
    fontPackage = mkOption {
      type = types.package;
      default = self'.packages.san-francisco-pro;
      description = "The font package.";
    };
  };
}

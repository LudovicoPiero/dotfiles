{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: let
    sources = pkgs.callPackage ./_sources/generated.nix {};
  in {
    packages = {
      iosevka-q = pkgs.callPackage ./iosevka-q {};

      firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme {inherit sources;};

      san-francisco-pro = pkgs.callPackage ./san-francisco-pro {inherit sources;};

      sarasa-gothic = pkgs.callPackage ./sarasa-gothic {};

      swayfx = pkgs.callPackage ./swayfx {inherit sources;};

      spotify = pkgs.callPackage ./spotify {};

      waybar = pkgs.callPackage ./waybar {inherit sources;};

      wezterm = pkgs.darwin.apple_sdk_11_0.callPackage ./wezterm {
        inherit
          (pkgs.darwin.apple_sdk_11_0.frameworks)
          Cocoa
          CoreGraphics
          Foundation
          UserNotifications
          System
          ;
        inherit sources;
      };

      whitesur-gtk-theme = pkgs.callPackage ./whitesur-gtk-theme {
        inherit (pkgs.gnome) gnome-shell;
        inherit sources;
      };
    };
  };
}

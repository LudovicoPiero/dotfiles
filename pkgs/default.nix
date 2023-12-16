{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      iosevka-q = pkgs.callPackage ./iosevka-q {};

      san-francisco-pro = pkgs.callPackage ./san-francisco-pro {};

      sarasa-gothic = pkgs.callPackage ./sarasa-gothic {};

      spotify = pkgs.callPackage ./spotify {};

      wezterm = pkgs.darwin.apple_sdk_11_0.callPackage ./wezterm {
        inherit (pkgs.darwin.apple_sdk_11_0.frameworks) Cocoa CoreGraphics Foundation UserNotifications System;
      };
    };
  };
}

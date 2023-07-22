{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      multicolor-sddm-theme = pkgs.callPackage ./multicolor-sddm-theme {};

      iosevka-q = pkgs.callPackage ./iosevka-q {};

      san-francisco-pro = pkgs.callPackage ./san-francisco-pro {};

      spotify = pkgs.callPackage ./spotify {};

      teavpn2 = pkgs.callPackage ./teavpn2 {};

      TLauncher = pkgs.callPackage ./TLauncher {};
    };
  };
}

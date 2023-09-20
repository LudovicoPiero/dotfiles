{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      multicolor-sddm-theme = pkgs.callPackage ./multicolor-sddm-theme {};

      iosevka-q = pkgs.callPackage ./iosevka-q {};

      san-francisco-pro = pkgs.callPackage ./san-francisco-pro {};

      spotify = pkgs.callPackage ./spotify {};

      TLauncher = pkgs.callPackage ./TLauncher {};

      webcord-vencord = pkgs.callPackage ./webcord-vencord {};
    };
  };
}

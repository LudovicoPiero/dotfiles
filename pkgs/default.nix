{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      geist-font = pkgs.callPackage ./geist-font {};

      multicolor-sddm-theme = pkgs.callPackage ./multicolor-sddm-theme {};

      iosevka-q = pkgs.callPackage ./iosevka-q {};

      san-francisco-pro = pkgs.callPackage ./san-francisco-pro {};

      spotify = pkgs.callPackage ./spotify {};

      wavefox = pkgs.callPackage ./wavefox {};
    };
  };
}

{
  perSystem = {pkgs, ...}: {
    packages = {
      iosevka-q = pkgs.callPackage ./iosevka-q {};

      san-francisco-pro = pkgs.callPackage ./san-francisco-pro {};

      spotify = pkgs.callPackage ./spotify {};
    };
  };
}

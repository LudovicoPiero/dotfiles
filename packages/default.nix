{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        iosevka-q = pkgs.callPackage ./iosevka-q { };
      };
    };
}

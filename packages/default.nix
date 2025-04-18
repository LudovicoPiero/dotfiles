{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, system, ... }:
    let
      sources = pkgs.callPackage ./_sources/generated.nix { };
    in
    {
      # This sets `pkgs` to a nixpkgs with allowUnfree option set.
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ ];
        config.allowUnfree = true;
      };

      packages = {
        catppuccin-fcitx5 = pkgs.callPackage ./catppuccin-fcitx5 { inherit sources; };

        iosevka-q = pkgs.callPackage ./iosevka-q { };

        firefox-gnome-theme = pkgs.callPackage ./firefox-gnome-theme { inherit sources; };

        pollymc = pkgs.callPackage ./pollymc { };

        tidal-hifi = pkgs.callPackage ./tidal-hifi { };

        san-francisco-pro = pkgs.callPackage ./san-francisco-pro { inherit sources; };

        sarasa-gothic = pkgs.callPackage ./sarasa-gothic { };

        spotify = pkgs.callPackage ./spotify { };

        whitesur-gtk-theme = pkgs.callPackage ./whitesur-gtk-theme { inherit sources; };
      };
    };
}

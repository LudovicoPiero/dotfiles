{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    {
      pkgs,
      system,
      lib,
      ...
    }:
    let
      sources = pkgs.callPackage ./_sources/generated.nix { };

      _pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.rust-overlay.overlays.default ];
        config.allowUnfree = true;
      };

      # Detect subdirectories that contain default.nix
      dirs = lib.filter (
        name:
        builtins.pathExists ./${name}/default.nix && !(lib.strings.hasPrefix "_" name)
      ) (builtins.attrNames (builtins.readDir ./.));

      # Safely call each package:
      # Try passing `sources`, and if it fails, retry without it.
      safeCall =
        path:
        let
          fn = import path;
          args = builtins.functionArgs fn;
        in
        if args ? sources then
          _pkgs.callPackage path { inherit sources; }
        else
          _pkgs.callPackage path { };

      packages = lib.listToAttrs (
        map (dir: {
          name = dir;
          value = safeCall ./${dir};
        }) dirs
      );
    in
    {
      _module.args.pkgs = _pkgs;
      inherit packages;
    };
}

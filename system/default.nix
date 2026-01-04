{ extendedLib, ... }:
let
  inherit (extendedLib.filesystem) listFilesRecursive;
  inherit (extendedLib.strings) hasSuffix;
  inherit (builtins)
    baseNameOf
    dirOf
    toString
    filter
    map
    listToAttrs
    ;

  # Find all configuration.nix files
  hostConfigs = filter (p: hasSuffix "/configuration.nix" (toString p)) (
    listFilesRecursive ./.
  );

  mkHostEntry =
    path:
    let
      hostDir = dirOf path;
      hostName = baseNameOf (toString hostDir);
    in
    {
      name = hostName;
      value = extendedLib.mkHost hostDir hostName;
    };
in
{
  flake.nixosConfigurations = listToAttrs (map mkHostEntry hostConfigs);
}

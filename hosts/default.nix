# hosts/default.nix
{
  withSystem,
  inputs,
  lib,
  ...
}:
let
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
  inherit (builtins)
    baseNameOf
    dirOf
    toString
    filter
    map
    ;

  mkHost = import ../lib/mkHost.nix { inherit withSystem inputs; };

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
      value = mkHost hostDir hostName;
    };
in
{
  flake.nixosConfigurations = builtins.listToAttrs (map mkHostEntry hostConfigs);
}

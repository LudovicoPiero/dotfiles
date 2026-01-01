{ lib, ... }:

let
  rootPath = ./.;

  scanPaths =
    path:
    let
      entries = builtins.readDir path;

      isValid = name: !lib.hasPrefix "_" name;

      processEntry =
        name: type:
        if !isValid name then
          [ ]

        else if type == "directory" then
          scanPaths (path + "/${name}")

        else if type == "regular" && lib.hasSuffix ".nix" name then
          if name == "default.nix" && path == rootPath then
            [ ]
          else
            [ (path + "/${name}") ]
        else
          [ ];
    in
    lib.flatten (lib.mapAttrsToList processEntry entries);
in
{
  imports = scanPaths rootPath;
}

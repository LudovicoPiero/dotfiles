# Thanks to: https://discourse.nixos.org/t/a-cool-function-to-import-nix-modules-automatically/62757/3
{ lib, ... }:
let
  inherit (builtins)
    filter
    map
    baseNameOf
    toString
    ;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasPrefix hasSuffix;

  # Filter function: skip hidden/internal paths starting with "_"
  validPath =
    p:
    let
      name = baseNameOf p;
    in
    !(hasPrefix "_" name);
in
{
  imports = filter (p: hasSuffix ".nix" p && validPath p) (
    map toString (filter (p: p != ./default.nix && validPath p) (listFilesRecursive ./.))
  );
}

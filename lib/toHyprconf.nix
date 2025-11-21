# lib/toHyprconf.nix
{ lib }:
let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    isAttrs
    isBool
    isList
    sort
    attrNames
    ;

  # Helper to safely convert types to strings (specifically booleans)
  formatValue =
    v: if isBool v then (if v then "true" else "false") else toString v;

  # Custom sorter: Forces 'bezier' to appear before 'animation'.
  # Hyprland requires beziers to be defined before they are referenced.
  hyprSort =
    a: b:
    if a == "bezier" then
      true
    else if b == "bezier" then
      false
    else
      a < b;

  render =
    name: value:
    if isAttrs value then
      let
        # We sort the keys using our custom sorter instead of mapAttrsToList
        sortedKeys = sort hyprSort (attrNames value);
        # Recursively render items in the sorted order
        innerContent = concatStringsSep "\n" (map (k: render k value.${k}) sortedKeys);
      in
      "${name} {\n${innerContent}\n}"
    else if isList value then
      concatStringsSep "\n" (map (v: "${name} = ${formatValue v}") value)
    else
      "${name} = ${formatValue value}";
in
attrs: concatStringsSep "\n" (mapAttrsToList render attrs)

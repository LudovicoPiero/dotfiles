{ pkgs, inputs', ... }:
let
  common = import ../_common.nix { inherit pkgs inputs'; };
in
{
  mine.programs.firefox.profiles.ludovico.search = {
    force = true;
    inherit (common.search) default order engines;
  };
}
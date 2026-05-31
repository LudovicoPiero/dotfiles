{ pkgs, inputs', ... }:
let
  common = import ../_common.nix { inherit pkgs inputs'; };
in
{
  mine.programs.firefox.profiles.ludovico.extensions = {
    force = true;
    packages = common.extensions;
    settings = common.extensionSettings;
  };
}

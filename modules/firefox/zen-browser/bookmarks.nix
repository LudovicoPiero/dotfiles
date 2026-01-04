{ pkgs, inputs', ... }:
let
  common = import ../_common.nix { inherit pkgs inputs'; };
in
{
  mine.programs.zen-browser.profiles.ludovico.bookmarks = {
    force = true;
    settings = common.bookmarks;
  };
}
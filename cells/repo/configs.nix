/*
  This file holds configuration data for repo dotfiles.

  Q: Why not just put the put the file there?

  A:
   (1) dotfile proliferation
   (2) have all the things in one place / format
   (3) potentially share / re-use configuration data - keeping it in sync
*/
{ inputs, cell }:
let
  inherit (inputs.std.data) configs;
  inherit (inputs.std.lib.dev) mkNixago;
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) nixpkgs;
in
{
  # Tool Homepage: https://editorconfig.org/
  editorconfig = (mkNixago configs.editorconfig) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/editorconfig.nix
    data = { };
  };

  # Tool Homepage: https://numtide.github.io/treefmt/
  treefmt = (mkNixago configs.treefmt) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/treefmt.nix
    data = {
      formatter = {
        nix = {
          command = lib.getExe nixpkgs.nixfmt-rfc-style;
        };
        stylua = {
          command = lib.getExe nixpkgs.stylua;
          includes = [ "*.lua" ];
          options = [
            "--indent-type"
            "Spaces"
            "--indent-width"
            "2"
            "--quote-style"
            "ForceDouble"
          ];
        };
      };
    };
  };

  # Tool Homepage: https://github.com/evilmartians/lefthook
  lefthook = (mkNixago configs.lefthook) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/lefthook.nix
    data = lib.mkForce {
      pre-commit = {
        parallel = true;
        commands = {
          treefmt = {
            run = "${lib.getExe nixpkgs.treefmt} --fail-on-change {staged_files}";
            skip = [
              "merge"
              "rebase"
            ];
          };
        };
      };
    };
  };
}

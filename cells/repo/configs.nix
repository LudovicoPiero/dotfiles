/*
This file holds configuration data for repo dotfiles.

Q: Why not just put the put the file there?

A:
 (1) dotfile proliferation
 (2) have all the things in one place / format
 (3) potentially share / re-use configuration data - keeping it in sync
*/
{
  inputs,
  cell,
}: let
  # inherit (inputs) nixpkgs;
  # inherit (inputs.nixpkgs) lib;
  inherit (inputs.std.data) configs;
  inherit (inputs.std.lib.dev) mkNixago;
in {
  # Tool Homepage: https://editorconfig.org/
  editorconfig = (mkNixago configs.editorconfig) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/editorconfig.nix
    hook.mode = "copy"; # already useful before entering the devshell

    data = {
      root = true;

      "*" = {
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
        charset = "utf-8";
        indent_style = "space";
        indent_size = 2;
      };

      "*.{diff,patch}" = {
        end_of_line = "unset";
        insert_final_newline = "unset";
        trim_trailing_whitespace = "unset";
        indent_size = "unset";
      };

      "*.md" = {
        max_line_length = "off";
        trim_trailing_whitespace = false;
      };
      "{LICENSES/**,LICENSE}" = {
        end_of_line = "unset";
        insert_final_newline = "unset";
        trim_trailing_whitespace = "unset";
        charset = "unset";
        indent_style = "unset";
        indent_size = "unset";
      };
    };
  };

  # Tool Homepage: https://numtide.github.io/treefmt/
  treefmt = (mkNixago configs.treefmt) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/treefmt.nix
    data = {};
  };

  conform = (mkNixago configs.conform) {
    data = {};
  };

  # Tool Homepage: https://github.com/evilmartians/lefthook
  lefthook = (mkNixago configs.lefthook) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/lefthook.nix
    data = {};
  };
  githubsettings = (mkNixago configs.githubsettings) {
    # see defaults at https://github.com/divnix/std/blob/main/src/data/configs/githubsettings.nix
    data = {
      repository = {
        name = "dotfiles";
        inherit (import (inputs.self + /flake.nix)) description;
        homepage = "https://github.com/LudovicoPiero/dotfiles";
        topics = "nixos";
        default_branch = "main";
        allow_squash_merge = true;
        allow_merge_commit = true;
        allow_rebase_merge = true;
        delete_branch_on_merge = true;
        private = false;
        has_issues = false;
        has_projects = false;
        has_wiki = false;
        has_downloads = false;
      };
    };
  };
}

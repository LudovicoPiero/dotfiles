{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    # This 2 didn't play well with divnix's std
    deadnix.enable = false;
    statix.enable = false;

    nixfmt.enable = true;
    nixfmt.package = pkgs.nixfmt-rfc-style;
    # statix.disabled-lints = ["repeated_keys"];
    stylua.enable = true;
  };
}

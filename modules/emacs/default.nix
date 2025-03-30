{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  emacsPackages = (
    pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs30-pgtk;
      config = ./config.org;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      extraEmacsPackages = e: [
        e.use-package
        e.treesit-grammars.with-all-grammars
        # LSPs
        pkgs.vscode-langservers-extracted
        pkgs.nixd
        pkgs.rust-analyzer
        pkgs.typescript-language-server
        pkgs.basedpyright
        pkgs.zls
        # linters
        pkgs.clippy
        pkgs.shellcheck
        # formatters
        pkgs.nixfmt-rfc-style
        pkgs.rustfmt
        pkgs.black
        pkgs.isort
      ];
      override = _: prev: {
        use-package = prev.emacs;
      };
    }
  );

  cfg = config.myOptions.emacs;
in
{
  options.myOptions.emacs = {
    enable = mkEnableOption "emacs service" // {
      default = config.vars.withGui;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.emacs.overlays.default
    ];

    home-manager.users.${config.vars.username} =
      { config, ... }:
      {
        services.emacs = {
          enable = true;
          package = config.programs.emacs.finalPackage;
          client.enable = true;
        };

        programs.emacs = {
          enable = true;
          package = emacsPackages;
        };
      }; # For Home-Manager options
  };
}

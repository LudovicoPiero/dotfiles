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

  emacs =
    with pkgs;
    (emacsPackagesFor emacs30-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
        mu4e
      ]
    );

  devTools = [
    # Language servers
    pkgs.vscode-langservers-extracted
    pkgs.nixd
    pkgs.rust-analyzer
    pkgs.typescript-language-server
    pkgs.basedpyright
    pkgs.zls
    # Linters
    pkgs.clippy
    pkgs.eslint
    pkgs.stylelint
    pkgs.ruff
    pkgs.shellcheck
    # Formatters
    pkgs.nixfmt-rfc-style
    pkgs.rustfmt
    pkgs.black
    pkgs.isort
    pkgs.nodePackages.prettier
    # Other tools
    pkgs.pinentry-emacs
  ];

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
          socketActivation.enable = false;
        };

        programs.emacs = {
          enable = true;
          package = emacs.overrideAttrs (o: {
            postFixup =
              (o.postFixup or "")
              + ''
                wrapProgram $out/bin/emacs --set PATH ${lib.makeBinPath devTools}
              '';
          });
        };
      }; # For Home-Manager options
  };
}

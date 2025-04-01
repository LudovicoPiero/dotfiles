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
          package =
            (pkgs.emacs-git-pgtk).emacsWithPackages
              (
                epkgs: with epkgs; [
                  treesit-grammars.with-all-grammars
                  vterm
                ]
              ).overrideAttrs
              (o: {
                postFixup =
                  o.postFixup
                  + ''
                    wrapProgram $out/bin/emacs \
                        --set PATH ${
                          lib.makeBinPath [
                            # LSPs
                            pkgs.vscode-langservers-extracted
                            pkgs.nixd
                            pkgs.rust-analyzer
                            pkgs.typescript-language-server
                            pkgs.basedpyright
                            pkgs.zls
                            # linters
                            pkgs.clippy
                            pkgs.eslint
                            pkgs.stylelint
                            pkgs.ruff
                            pkgs.shellcheck
                            # formatters
                            pkgs.nixfmt-rfc-style
                            pkgs.rustfmt
                            pkgs.black
                            pkgs.isort
                            pkgs.nodePackages.prettier

                            #etc
                            pkgs.pinentry-emacs
                          ]
                        }
                  '';
              });
        };
      }; # For Home-Manager options
  };
}

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

  #TODO: Find a better way to do this shit
  emacsWrapped = pkgs.symlinkJoin {
    name = "emacs-wrapped";
    paths = [ emacs ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --suffix PATH : "${lib.makeBinPath devTools}"
    '';
  };

  devTools = with pkgs; [
    # Language servers
    clang-tools
    go
    gopls
    vscode-langservers-extracted
    nixd
    rust-analyzer
    typescript-language-server
    basedpyright
    zls
    # Linters
    clippy
    eslint
    gotools
    stylelint
    ruff
    shellcheck
    # Formatters
    nixfmt-rfc-style
    rustfmt
    black
    isort
    nodePackages.prettier
    # Other tools
    pinentry-emacs
    ispell
  ];

  cfg = config.myOptions.emacs;
in
{
  options.myOptions.emacs = {
    enable = mkEnableOption "Emacs and its service" // {
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
          package = emacsWrapped;
        };
      };
  };
}

{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    makeBinPath
    concatLists
    ;
  cfg = config.mine.emacs;

  emacsPackage =
    with pkgs;
    (emacsPackagesFor emacs-git-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
      ]
    );

  # --- Tool Groups ---
  nixTools = with pkgs; [
    statix
    nixfmt
    nil
  ];

  goTools = with pkgs; [
    go
    gopls
    gotools
    golangci-lint
    gofumpt
  ];

  pythonTools = with pkgs; [
    basedpyright
    ruff
    black
  ];

  rustTools = with pkgs; [
    rust-analyzer
    rustfmt
    cargo
    clippy
  ];

  luaTools = with pkgs; [
    emmylua-ls
    emmylua-check
    stylua
    luajitPackages.luacheck
  ];

  cppTools = with pkgs; [
    clang-tools
    cmake-language-server
    mesonlsp
    gcc
    gn
    cmake-format
  ];

  commonTools = with pkgs; [
    copilot-language-server
    bash-language-server
    shellharden
    typescript-language-server
    haskell-language-server
    shfmt
    shellcheck
    nodePackages.prettier
    taplo
    marksman
    nodePackages.yaml-language-server
    vscode-langservers-extracted
    svelte-language-server
    chafa
    fzf
    ripgrep
    bat
    fd
  ];

  runtimeDeps = concatLists [
    nixTools
    goTools
    pythonTools
    rustTools
    luaTools
    cppTools
    commonTools
  ];

  # Symlinks all paths from emacsPackage (including share/)
  # and wraps the binary with the required PATH.
  emacsWrapped = pkgs.symlinkJoin {
    name = "emacs-wrapped";
    paths = [ emacsPackage ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --prefix PATH : ${makeBinPath runtimeDeps}
    '';
  };
in
{
  options.mine.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    hj.packages = [ emacsWrapped ];
  };
}

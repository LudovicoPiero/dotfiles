{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.mine.emacs;

  emacsPackage =
    with pkgs;
    (emacsPackagesFor emacs-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
      ]
    );

  runtimeDeps = with pkgs; [
    fzf
    ripgrep
    fd
    imagemagick
    zstd
    nixd
    nixfmt-rfc-style
    clang-tools
    cmake
    basedpyright
    python3
    black
    ruff
    go
    gopls
    rust-analyzer
    clippy
    rustfmt
    prettierd
    vscode-langservers-extracted
    typescript-language-server
    intelephense
    astro-language-server
    vue-language-server
    tailwindcss-language-server
    sqlite
    libvterm
  ];

  emacsWrapped = pkgs.runCommand "emacs-wrapped" { buildInputs = [ pkgs.makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${emacsPackage}/bin/emacs $out/bin/emacs \
      --prefix PATH : ${
        pkgs.buildEnv {
          name = "emacs-path";
          paths = runtimeDeps;
        }
      }/bin
  '';
in
{
  options.mine.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    hm.home.packages = [ emacsWrapped ];
  };
}

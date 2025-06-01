{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (inputs) emacs-overlay wrapper-manager;

  emacsPackage =
    with pkgs;
    (emacsPackagesFor emacs-git-pgtk).emacsWithPackages (
      epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
        vterm
      ]
    );

  cfg = config.mine.emacs;
in
{
  options.mine.emacs.enable = mkEnableOption "Emacs";

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ emacs-overlay.overlays.default ];

    hj.packages = [
      (wrapper-manager.lib.build {
        inherit pkgs;
        modules = [
          {
            wrappers.emacs = {
              basePackage = emacsPackage;
              pathAdd = with pkgs; [
                ## Optional dependencies
                (mkIf (config.programs.gnupg.agent.enable) pinentry-emacs) # in-emacs gnupg prompts
                (aspellWithDicts (
                  ds: with ds; [
                    en
                    en-computers
                    en-science
                  ]
                ))
                # https://github.com/manateelazycat/lsp-bridge/wiki/NixOS
                (python3.withPackages (
                  p: with p; [
                    epc
                    orjson
                    sexpdata
                    six
                    setuptools
                    paramiko
                    rapidfuzz
                    watchdog
                    packaging
                  ]
                ))

                ripgrep
                fd # faster projectile indexing
                imagemagick # for image-dired
                zstd # for undo-fu-session/undo-tree compression

                # Nix
                nixd
                nixfmt-rfc-style

                # C
                clang-tools
                cmake

                # Python
                basedpyright
                python3
                black
                ruff

                # Go
                go
                gopls

                # Rust
                rust-analyzer
                clippy
                rustfmt

                # Web Development
                vscode-langservers-extracted
                typescript-language-server
                intelephense # php
                astro-language-server
                vue-language-server
                tailwindcss-language-server
              ];
            };
          }
        ];
      })
    ];
  };
}

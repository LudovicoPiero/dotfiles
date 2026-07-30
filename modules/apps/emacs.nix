{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.mine.emacs;

  treesit-grammars = pkgs.tree-sitter.withPlugins (
    p: with p; [
      tree-sitter-nix
      tree-sitter-python
      tree-sitter-go
      tree-sitter-rust
      tree-sitter-c
      tree-sitter-cpp
      tree-sitter-bash
      tree-sitter-json
      tree-sitter-toml
      tree-sitter-yaml
      tree-sitter-markdown
      tree-sitter-markdown_inline
    ]
  );

  emacs-wrapped = inputs.wrapper-manager.lib {
    inherit pkgs;
    modules = [
      {
        wrappers.emacs = {
          basePackage = cfg.package;
          pathAdd = [
            pkgs.ripgrep
            pkgs.fd
            pkgs.git
          ]
          ++ lib.optionals cfg.lsp.nix.enable [
            pkgs.nil
            pkgs.deadnix
            pkgs.statix
            pkgs.nixfmt
          ]
          ++ lib.optionals cfg.lsp.python.enable [
            pkgs.pyright
            pkgs.ruff
          ]
          ++ lib.optionals cfg.lsp.go.enable [
            pkgs.gopls
            pkgs.go
            pkgs.gotools
          ]
          ++ lib.optionals cfg.lsp.rust.enable [
            pkgs.rust-analyzer
            pkgs.rustfmt
          ];
          # env.TREE_SITTER_GRAMMAR_PATH.value = "${treesit-grammars}/parser";
        };
      }
    ];
  };

  emacs-package = emacs-wrapped.config.wrappers.emacs.wrapped;
in
{
  options.mine.emacs = {
    enable = lib.mkEnableOption "Emacs text editor";

    daemon.enable = lib.mkEnableOption "Emacs systemd user service (daemon mode)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.emacs-pgtk;
      defaultText = lib.literalExpression "pkgs.emacs-pgtk";
      description = "Emacs package to use.";
    };

    lsp = {
      nix.enable = lib.mkEnableOption "Nix LSP toolchain (nil, deadnix, statix, nixfmt-rfc-style)";
      python.enable = lib.mkEnableOption "Python LSP (pyright)";
      go.enable = lib.mkEnableOption "Go LSP and toolchain (gopls, go)";
      rust.enable = lib.mkEnableOption "Rust LSP (rust-analyzer)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable { environment.systemPackages = [ emacs-package ]; })

    (lib.mkIf cfg.daemon.enable {
      services.emacs = {
        enable = true;
        package = emacs-package;
      };
    })
  ];
}

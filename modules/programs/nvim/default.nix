# NOTE: Thanks Gerg 🏴‍☠️
# https://github.com/Gerg-L/nvim-flake/blob/master/config.nix
{
  config,
  lib,
  inputs,
  inputs',
  self',
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.nvim;

  npinsToPlugins =
    input: builtins.mapAttrs (_: v: v { inherit pkgs; }) (import ./npins/_npins.nix { inherit input; });
in
{
  imports = [ inputs.mnw.nixosModules.default ];

  options.mine.nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nvim.";
    };

    package = mkOption {
      type = types.package;
      inherit (inputs'.nvim-overlay.packages) default;
      description = "The nvim package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs.mnw = {
      enable = true;

      neovim = cfg.package;

      luaFiles = [ ./init.lua ];

      plugins = {
        start = [
          pkgs.vimPlugins.lazy-nvim
          pkgs.vimPlugins.plenary-nvim
        ];

        # Anything that you're loading lazily should be put here
        opt = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];
        optAttrs = {
          "blink.cmp" = self'.packages.blink-cmp;
          "blink.pairs" = self'.packages.blink-pairs;
        }
        // npinsToPlugins ./npins/sources.json;

        dev.lain = {
          # is this necessary?
          pure = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./lua
              ./init.lua
            ];
          };
        };
      };

      extraLuaPackages = p: [ p.jsregexp ];
      providers = {
        ruby.enable = true;
        python3.enable = true;
        nodeJs.enable = true;
        perl.enable = true;
      };

      extraBinPath = with pkgs; [
        # --- Nix ---
        statix
        nixfmt
        nixd

        # --- Go ---
        go
        gopls
        gotools
        golangci-lint
        gofumpt

        # --- Python ---
        basedpyright
        ruff
        black

        # --- Rust ---
        rust-analyzer
        rustfmt
        cargo
        clippy

        # --- Lua ---
        emmylua-ls # LSP for Lua (also known as sumneko_lua)
        emmylua-check
        stylua # Lua code formatter
        luajitPackages.luacheck # Lua linter

        # --- C/C++ ---
        clang-tools # includes clangd, clang-format, etc.
        cmake-language-server
        mesonlsp
        gcc

        # --- Common tools ---
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
        # inputs'.self.packages.tree-sitter-cli #TODO
      ];
    };
  };
}

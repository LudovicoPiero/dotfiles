{
  config,
  lib,
  inputs,
  inputs',
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.nvim;
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
      default = inputs'.nvim.packages.default;
      description = "The nvim package to install.";
    };
  };

  config = mkIf cfg.enable {
    programs.mnw = {
      enable = true;
      initLua = ''
        require("lain")
      '';

      plugins = {
        opt = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
        optAttrs = {
          #TODO: https://github.com/Gerg-L/nvim-flake/blob/cc168eb146aa258b815ba97491d534eea6cf4aa8/packages/blink-cmp/package.nix
          "blink.cmp" = inputs'.blink-cmp.packages.default;
        };

        dev.lain = {
          pure = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [ ./lua ];
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

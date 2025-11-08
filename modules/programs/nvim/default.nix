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
        #TODO: use npins like gerg
        opt = with pkgs.vimPlugins; [
          # Completion / Snippets
          blink-cmp
          luasnip
          friendly-snippets
          lspkind-nvim
          blink-compat
          blink-copilot
          copilot-lua

          # Appearance / UI / Themes
          tokyonight-nvim
          indent-blankline-nvim
          bufferline-nvim

          # Navigation / Motion
          flash-nvim
          yazi-nvim
          fzf-lua

          # Code / LSP / Development
          nvim-lspconfig
          conform-nvim
          lazydev-nvim
          mini-nvim

          # Project / Git / Todo
          todo-comments-nvim
          gitsigns-nvim

          # Misc / Utilities
          trouble-nvim
          which-key-nvim
          nvim-web-devicons

          # Parsing / Treesitter
          nvim-treesitter.withAllGrammars
        ];

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

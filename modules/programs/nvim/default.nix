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
        require("config.lazy")
      '';

      plugins = {
        opt = [pkgs.vimPlugins.nvim-treesitter.withAllGrammars];
        start = with pkgs.vimPlugins; [
          lazy-nvim
          gruvbox-nvim
          trouble-nvim
          cmp-emoji
          lualine-nvim
          typescript-nvim
          nui-nvim
          gitsigns-nvim
          nvim-colorizer-lua
        ];

        dev.config = {
          pure = ./nvim;
          # impure =
          #   # This is a hack it should be a absolute path
          #   # here it'll only work from this directory
          #   "/' .. vim.uv.cwd()  .. '/nvim";
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
        nil
        statix
        nixd

        # --- Go ---
        gopls
        golangci-lint
        gofumpt

        # --- Python ---
        pyright
        ruff
        black

        # --- Rust ---
        rust-analyzer
        rustfmt
        cargo
        clippy

        # --- C/C++ ---
        clang-tools # includes clangd, clang-format, etc.
        gcc

        # --- Common tools ---
        shfmt
        shellcheck
        stylua
        nodePackages.prettier
        taplo
        marksman
        nodePackages.yaml-language-server
        vscode-langservers-extracted
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}: let
  catppuccin-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "catppuccin-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "72540852ca00d7842ea1123635aecb9353192f0b";
      sha256 = "0mb3qhg5aaxvkc8h95sbwg5nm89w719l9apymc5rpmis4r0mr5zg";
    };
  };
  jabuti-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "jabuti-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "jabuti-theme";
      repo = "jabuti-nvim";
      rev = "17f1b94cbf1871a89cdc264e4a8a2b3b4f7c76d2";
      sha256 = "sha256-iPjwx/rTd98LUPK1MUfqKXZhQ5NmKx/rN8RX1PIuDFA=";
    };
  };
in {
  home.file.".config/nvim/settings.lua".source = ./init.lua;

  home.packages = with pkgs; [
    rnix-lsp
    nixfmt # Nix
    sumneko-lua-language-server
    stylua # Lua
  ];

  programs.neovim = {
    enable = true;
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      plenary-nvim
      nvim-tree-lua
      dashboard-nvim
      copilot-vim
      lualine-nvim
      nerdtree
      {
        plugin = bufferline-nvim;
        config = "lua require('bufferline').setup()";
      }
      {
        plugin = zk-nvim;
        config = "lua require('zk').setup()";
      }
      {
        plugin = nvim-colorizer-lua;
        config = "lua require('colorizer').setup()";
      }
      {
        plugin = impatient-nvim;
        config = "lua require('impatient')";
      }
      {
        plugin = telescope-nvim;
        config = "lua require('telescope').setup()";
      }
      {
        plugin = indent-blankline-nvim;
        config = "lua require('indent_blankline').setup()";
      }
      {
        plugin = catppuccin-nvim;
        config = ''
          lua << EOF
          require('catppuccin').setup {
          	flavour = 'mocha',
          }
          EOF
        '';
      }
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin";
      }
      {
        plugin = nvim-lspconfig;
        config = ''
          lua << EOF
          require('lspconfig').rust_analyzer.setup{}
          require('lspconfig').sumneko_lua.setup{}
          require('lspconfig').rnix.setup{}
          require('lspconfig').zk.setup{}
          EOF
        '';
      }
      {
        plugin = nvim-treesitter;
        config = ''
          lua << EOF
          require('nvim-treesitter.configs').setup {
              highlight = {
                  enable = true,
                  additional_vim_regex_highlighting = false,
              },
          }
          EOF
        '';
      }
    ];

    extraConfig = ''
      luafile ~/.config/nvim/settings.lua
    '';
  };
}

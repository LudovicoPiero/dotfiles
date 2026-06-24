{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nvf.nixosModules.default ];

  options.mine.nvim = {
    enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf = {
      enable = true;
      defaultEditor = true;

      settings.vim = {
        viAlias = true;
        vimAlias = true;

        spellcheck = {
          enable = true;
          programmingWordlist.enable = false; #FIXME
        };

        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers = {
            wl-copy.enable = true;
            xclip.enable = true;
          };
        };

        options = {
          # UI
          number = true;
          relativenumber = true;
          cursorline = true;
          signcolumn = "yes";
          termguicolors = true;
          showmode = false;
          scrolloff = 10;
          colorcolumn = "80,100";
          laststatus = 3;

          # Modern features
          smoothscroll = true;
          splitkeep = "screen";

          # Cursor and input
          mouse = "a";
          guicursor = "n-v-i-c:block-Cursor";
          timeoutlen = 300;

          # Indentation
          expandtab = true;
          smartindent = true;
          shiftwidth = 2;
          tabstop = 2;
          softtabstop = 2;
          breakindent = true;

          # Search
          ignorecase = true;
          smartcase = true;
          hlsearch = true;
          inccommand = "split";

          # Splits
          splitbelow = true;
          splitright = true;

          # File and undo
          undofile = true;
          swapfile = false;
          updatetime = 250;
          exrc = true;

          # Visual characters
          list = true;
        };

        globals = {
          mapleader = " ";
          maplocalleader = ",";
        };

        # Injecting complex options not easily expressed as flat primitives
        luaConfigRC.optionsVisuals = ''
          vim.opt.winborder = "rounded"
          vim.opt.fillchars = {
            eob = " ",
            vert = "│",
            fold = " ",
            diff = "╱",
          }
          vim.opt.listchars = {
            tab = "  ",
            trail = "·",
            extends = "›",
            precedes = "‹",
            nbsp = "␣",
          }
        '';

        # Diagnostics
        diagnostics.config = {
          virtual_text = true;
          signs = true;
          underline = true;
          update_in_insert = false;
          severity_sort = true;
        };
      };
    };
  };
}

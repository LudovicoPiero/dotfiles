{
  config,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nvf.nixosModules.default ];

  options.mine.neovim = {
    enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        viAlias = true;
        vimAlias = true;

        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers = {
            wl-copy.enable = true;
            xclip.enable = true;
          };
        };

        # Core options
        options = {
          number = true;
          relativenumber = true;
          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          wrap = false;
          scrolloff = 8;
          signcolumn = "yes";
          cursorline = true;
          splitbelow = true;
          splitright = true;
          updatetime = 50;
        };

        globals = {
          mapleader = " ";
          maplocalleader = ",";
        };

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

{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      lsp.trouble = {
        enable = true;
        setupOpts = {
          auto_close = false;
          focus = true;
          icons = {
            indent = {
              top = "│ ";
              middle = "├╴";
              last = "└╴";
              fold_open = " ";
              fold_closed = " ";
              ws = "  ";
            };
            folder_closed = " ";
            folder_open = " ";
          };
        };
      };

      keymaps = [
        {
          key = "<leader>xx";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle("diagnostics") end'';
          desc = "Diagnostics (Workspace)";
        }
        {
          key = "<leader>xX";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end'';
          desc = "Diagnostics (Buffer)";
        }
        {
          key = "<leader>sd";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end'';
          desc = "Document Diagnostics";
        }
        {
          key = "<leader>sD";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle("diagnostics") end'';
          desc = "Workspace Diagnostics";
        }
        # LSP symbols
        {
          key = "<leader>cs";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle({ mode = "symbols", focus = false }) end'';
          desc = "LSP Symbols";
        }
        # LSP references/definitions
        {
          key = "<leader>cl";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle({ mode = "lsp", focus = false, win = { position = "right" } }) end'';
          desc = "LSP Definitions / References";
        }
        {
          key = "<leader>xL";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle("loclist") end'';
          desc = "Location List";
        }
        # Quickfix list
        {
          key = "<leader>xQ";
          mode = "n";
          lua = true;
          action = ''function() require("trouble").toggle("qflist") end'';
          desc = "Quickfix List";
        }
      ];
    };
  };
}

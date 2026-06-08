{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim.git = {
      gitsigns = {
        enable = true;
        setupOpts = {
          signs = {
            add.text = "▎";
            change.text = "▎";
            delete.text = "";
            topdelete.text = "";
            changedelete.text = "▎";
          };
          current_line_blame = false;
        };
      };

      neogit = {
        enable = true;
        setupOpts.integrations.diffview = true;
      };
    };

    programs.nvf.settings.vim.keymaps = [
      {
        key = "<leader>gl";
        mode = "n";
        action = ":Neogit<CR>";
        silent = true;
        desc = "Neogit (Git TUI)";
      }
    ];
  };
}

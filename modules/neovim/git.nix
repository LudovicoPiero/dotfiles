_: {
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
    {
      key = "]h";
      mode = "n";
      lua = true;
      action = ''function() require("gitsigns").nav_hunk("next") end'';
      desc = "Next Hunk";
    }
    {
      key = "[h";
      mode = "n";
      lua = true;
      action = ''function() require("gitsigns").nav_hunk("prev") end'';
      desc = "Prev Hunk";
    }
    {
      key = "<leader>hs";
      mode = "n";
      lua = true;
      action = ''function() require("gitsigns").stage_hunk() end'';
      desc = "Stage Hunk";
    }
    {
      key = "<leader>hr";
      mode = "n";
      lua = true;
      action = ''function() require("gitsigns").reset_hunk() end'';
      desc = "Reset Hunk";
    }
    {
      key = "<leader>hp";
      mode = "n";
      lua = true;
      action = ''function() require("gitsigns").preview_hunk() end'';
      desc = "Preview Hunk";
    }
    {
      key = "<leader>hb";
      mode = "n";
      lua = true;
      action = ''function() require("gitsigns").blame_line({ full = true }) end'';
      desc = "Blame Line";
    }
  ];
}

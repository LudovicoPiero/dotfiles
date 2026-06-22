{ inputs, ... }: {
  programs.nvf.settings.vim = {
    mini = {
      ai = {
        enable = true;
        setupOpts.n_lines = 500;
      };

      splitjoin.enable = true;

      surround = {
        enable = true;
        setupOpts.mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };

      statusline = {
        enable = true;
        setupOpts = {
          statusline.section_location = ''
            return "%2l:%-2v"
          '';
        };
      };

      misc = {
        enable = true;
      };
    };

    luaConfigRC.mini-misc = inputs.nvf.lib.nvim.dag.entryAnywhere ''
      vim.filetype.add({
        filename = {
          ["COMMIT_EDITMSG"] = "gitcommit",
          ["git-rebase-todo"] = "gitrebase",
        },
      })

      local misc = require("mini.misc")
      misc.setup()
      vim.g.minimisc_restore_cursor_ignore_filetypes = { "gitcommit", "gitrebase" }
      misc.setup_restore_cursor()
    '';
  };
}

{
  config,
  lib,
  inputs,
  ...
}:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      mini.ai = {
        enable = true;
        setupOpts.n_lines = 500;
      };

      mini.splitjoin.enable = true;

      mini.surround = {
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

      mini.statusline = {
        enable = true;
        setupOpts = {
          statusline.section_location = "";
        };
      };

      mini.misc = {
        enable = true;
      };

      luaConfigRC.mini-misc = inputs.nvf.lib.nvim.dag.entryAnywhere ''
        local misc = require("mini.misc")
        misc.setup()

        vim.filetype.add({
          filename = {
            ["COMMIT_EDITMSG"] = "gitcommit",
            ["git-rebase-todo"] = "gitrebase",
          },
        })

        vim.g.minimisc_restore_cursor_ignore_filetypes = { "gitcommit", "gitrebase" }
        misc.setup_restore_cursor()

        -- Override mini.statusline location section to show LINE:COL
        local statusline = require("mini.statusline")
        statusline.section_location = function()
          return "%2l:%-2v"
        end
      '';
    };
  };
}

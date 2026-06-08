{
  config,
  lib,
  inputs,
  ...
}:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      binds.whichKey = {
        enable = true;
        setupOpts = {
          delay = 300;
          icons = {
            breadcrumb = "»";
            separator = "➜";
            group = "+";
          };
        };
      };

      # Register group labels using raw Lua after which-key is set up
      luaConfigRC.which-key-groups = inputs.nvf.lib.nvim.dag.entryAnywhere ''
        local wk = require("which-key")
        wk.add({
          { "<leader>c", group = "Code" },
          { "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
          { "<leader>h", group = "Hunks" },
          { "<leader>r", group = "Rename/Refactor" },
          { "<leader>t", group = "Toggle" },
          { "<leader>x", group = "Diagnostics/Trouble" },
        })
      '';
    };
  };
}

{

  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        pairs = { };
        bufremove = { };
        comment = {
          custom_commentstring = ''
            function()
              return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
            end
          '';
        };
        surround = {
          mappings = {
            add = "gsa"; # -- Add surrounding in Normal and Visual modes
            delete = "gsd"; # -- Delete surrounding
            find = "gsf"; # -- Find surrounding (to the right)
            find_left = "gsF"; # -- Find surrounding (to the left)
            highlight = "gsh"; # -- Highlight surrounding
            replace = "gsr"; # -- Replace surrounding
            update_n_lines = "gsn"; # -- Update `n_lines`
          };
        };
        ai = {
          n_lines = 500;
          custom_textobjects = {
            o = ''
              ai.gen_spec.treesitter({
                          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                        }, {})'';
            f = ''ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {})'';
            c = ''ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {})'';
            t = ''{ "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }'';
          };
        };
      };
    };
    keymaps = [
      {
        action = ''
          function()
            vim.g.minipairs_disable = not vim.g.minipairs_disable
          end
        '';
        key = "<leader>up";
        options.desc = "Toggle auto pairs";
      }
      {
        action = ''
          function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end
        '';
        key = "<leader>bd";
        options = {
          desc = "Delete Buffer";
        };
      }
      {
        action = ''
          function()
            require("mini.bufremove").delete(0, true)
          end
        '';
        key = "<leader>bD";
        options = {
          desc = "Delete Buffer (Force)";
        };
      }
    ];
  };
}

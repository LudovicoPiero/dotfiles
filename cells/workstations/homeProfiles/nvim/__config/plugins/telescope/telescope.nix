{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      extensions = {
        file-browser = {
          enable = true;
          settings = {
            hijack_netrw = true;
            theme = "dropdown";
          };
        };
        fzf-native = {
          enable = true;
        };
        ui-select = {
          settings = {
            specific_opts = {
              codeactions = true;
            };
          };
        };
        undo = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          mappings = {
            i = {
              "<esc>" = {
                __raw = ''
                  function(...)
                    return require("telescope.actions").close(...)
                  end'';
              };
            };
          };
        };
      };
      keymaps = {
        "<leader>sf" = {
          action = "find_files";
          options.desc = "[S]earch [F]iles";
        };
        "<leader>:" = {
          action = "command_history";
          options.desc = "[:] View command history";
        };
        "<leader><space>" = {
          action = "buffers";
          options.desc = "[ ] Find existing buffers";
        };
        "<leader>fr" = {
          action = "oldfiles";
          options.desc = "Recent";
        };
        "<leader>/" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "[/] Fuzzily search in current buffer";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Buffers";
        };
        "<C-p>" = {
          action = "git_files";
          options.desc = "Search git files";
        };
        "<leader>gc" = {
          action = "git_commits";
          options.desc = "Commits";
        };
        "<leader>gs" = {
          action = "git_status";
          options.desc = "Status";
        };
        "<leader>sa" = {
          action = "autocommands";
          options.desc = "Auto Commands";
        };
        "<leader>sb" = {
          action = "current_buffer_fuzzy_find";
          options.desc = "Buffer";
        };
        "<leader>sc" = {
          action = "command_history";
          options.desc = "Command History";
        };
        "<leader>sC" = {
          action = "commands";
          options.desc = "Commands";
        };
        "<leader>sD" = {
          action = "diagnostics";
          options.desc = "Workspace diagnostics";
        };
        "<leader>sh" = {
          action = "help_tags";
          options.desc = "Help pages";
        };
        "<leader>sH" = {
          action = "highlights";
          options.desc = "Search Highlight Groups";
        };
        "<leader>sk" = {
          action = "keymaps";
          options.desc = "Keymaps";
        };
        "<leader>sM" = {
          action = "man_pages";
          options.desc = "Man pages";
        };
        "<leader>sm" = {
          action = "marks";
          options.desc = "Jump to Mark";
        };
        "<leader>so" = {
          action = "vim_options";
          options.desc = "Options";
        };
        "<leader>sR" = {
          action = "resume";
          options.desc = "Resume";
        };
        "<leader>uC" = {
          action = "colorscheme";
          options.desc = "Colorscheme preview";
        };
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>fp";
        action = "<cmd>Telescope projects<CR>";
        options = {
          desc = "[F]ind [P]rojects";
        };
      }
      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>Telescope diagnostics bufnr=0<cr>";
        options = {
          desc = "Document diagnostics";
        };
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>Telescope live_grep<cr>";
        options = {
          desc = "[S]earch by [G]rep";
        };
      }
      {
        mode = "n";
        key = "<leader>st";
        action = "<cmd>TodoTelescope<cr>";
        options = {
          silent = true;
          desc = "Todo (Telescope)";
        };
      }
    ];
    extraConfigLua = ''
      local telescope = require('telescope')
      telescope.setup{
          pickers = {
            colorscheme = {
              enable_preview = true
            }
          }
      }
    '';
  };
}

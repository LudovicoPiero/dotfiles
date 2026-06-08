{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      telescope = {
        enable = true;
        setupOpts.defaults = {
          layout_strategy = "horizontal";
          path_display = [ "truncate" ];
        };
      };

      keymaps = [
        # Files (was snacks.picker.files)
        {
          key = "<leader>sf";
          mode = "n";
          action = ":Telescope find_files<CR>";
          silent = true;
          desc = "Search Files";
        }
        # Recent files (was snacks.picker.recent)
        {
          key = "<leader>s.";
          mode = "n";
          action = ":Telescope oldfiles<CR>";
          silent = true;
          desc = "Recent Files";
        }
        # Buffers (was snacks.picker.buffers)
        {
          key = "<leader><leader>";
          mode = "n";
          action = ":Telescope buffers<CR>";
          silent = true;
          desc = "Open Buffers";
        }
        # Live grep (was snacks.picker.grep)
        {
          key = "<leader>sg";
          mode = "n";
          action = ":Telescope live_grep<CR>";
          silent = true;
          desc = "Live Grep";
        }
        # Grep word (was snacks.picker.grep_word)
        {
          key = "<leader>sw";
          mode = [
            "n"
            "x"
          ];
          action = ":Telescope grep_string<CR>";
          silent = true;
          desc = "Grep Current Word";
        }
        # Grep buffer lines (was snacks.picker.lines)
        {
          key = "<leader>/";
          mode = "n";
          action = ":Telescope current_buffer_fuzzy_find<CR>";
          silent = true;
          desc = "Grep Buffer";
        }
        # Quickfix (was snacks.picker.qflist)
        {
          key = "<leader>sq";
          mode = "n";
          action = ":Telescope quickfix<CR>";
          silent = true;
          desc = "Quickfix List";
        }
        # Help (was snacks.picker.help)
        {
          key = "<leader>sh";
          mode = "n";
          action = ":Telescope help_tags<CR>";
          silent = true;
          desc = "Search Help";
        }
        # Keymaps (was snacks.picker.keymaps)
        {
          key = "<leader>sk";
          mode = "n";
          action = ":Telescope keymaps<CR>";
          silent = true;
          desc = "Search Keymaps";
        }
        # LSP symbols
        {
          key = "<leader>cs";
          mode = "n";
          action = ":Telescope lsp_document_symbols<CR>";
          silent = true;
          desc = "LSP Symbols";
        }
        {
          key = "<leader>cl";
          mode = "n";
          action = ":Telescope lsp_references<CR>";
          silent = true;
          desc = "LSP Definitions / References";
        }
        # Git commits
        {
          key = "<leader>gc";
          mode = "n";
          action = ":Telescope git_commits<CR>";
          silent = true;
          desc = "Git Commits";
        }
      ];
    };
  };
}

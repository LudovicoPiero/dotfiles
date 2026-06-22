_: {
  programs.nvf.settings.vim = {
    fzf-lua = {
      enable = true;
      setupOpts = {
        winopts = {
          height = 0.9;
          width = 0.9;
          preview = {
            vertical = "down:50%";
            horizontal = "right:50%";
          };
        };
      };
    };

    keymaps = [
      # Files
      {
        key = "<leader>sf";
        mode = "n";
        action = ":FzfLua files<CR>";
        silent = true;
        desc = "Search Files";
      }
      # Recent files
      {
        key = "<leader>s.";
        mode = "n";
        action = ":FzfLua oldfiles<CR>";
        silent = true;
        desc = "Recent Files";
      }
      # Buffers
      {
        key = "<leader><leader>";
        mode = "n";
        action = ":FzfLua buffers<CR>";
        silent = true;
        desc = "Open Buffers";
      }
      # Live grep
      {
        key = "<leader>sg";
        mode = "n";
        action = ":FzfLua live_grep<CR>";
        silent = true;
        desc = "Live Grep";
      }
      # Grep word
      {
        key = "<leader>sw";
        mode = [
          "n"
          "x"
        ];
        action = ":FzfLua grep_cword<CR>";
        silent = true;
        desc = "Grep Current Word";
      }
      # Grep buffer lines
      {
        key = "<leader>/";
        mode = "n";
        action = ":FzfLua lgrep_curbuf<CR>";
        silent = true;
        desc = "Grep current buffer";
      }
      # Quickfix
      {
        key = "<leader>sq";
        mode = "n";
        action = ":FzfLua quickfix<CR>";
        silent = true;
        desc = "Quickfix List";
      }
      # Help
      {
        key = "<leader>sh";
        mode = "n";
        action = ":FzfLua help_tags<CR>";
        silent = true;
        desc = "Search Help";
      }
      # Keymaps
      {
        key = "<leader>sk";
        mode = "n";
        action = ":FzfLua keymaps<CR>";
        silent = true;
        desc = "Search Keymaps";
      }
      # LSP symbols
      {
        key = "<leader>cs";
        mode = "n";
        action = ":FzfLua lsp_document_symbols<CR>";
        silent = true;
        desc = "LSP Symbols";
      }
      {
        key = "<leader>cl";
        mode = "n";
        action = ":FzfLua lsp_references<CR>";
        silent = true;
        desc = "LSP Definitions / References";
      }
      # Git commits
      {
        key = "<leader>gc";
        mode = "n";
        action = ":FzfLua git_commits<CR>";
        silent = true;
        desc = "Git Commits";
      }
    ];
  };
}

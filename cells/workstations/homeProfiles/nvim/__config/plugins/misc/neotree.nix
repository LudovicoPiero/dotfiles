{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];
      filesystem = {
        bindToCwd = false;
        followCurrentFile = {
          enabled = true;
        };
        useLibuvFileWatcher = true;
      };
      window.mappings = {
        "<space>" = "none";
      };
      defaultComponentConfigs = {
        indent = {
          withExpanders = true;
          expanderCollapsed = "";
          expanderExpanded = "";
          expanderHighlight = "NeoTreeExpander";
        };
        gitStatus.symbols = {
          unstaged = "󰄱";
          staged = "󰱒";
        };
      };
    };

    keymaps = [
      {
        action = "<cmd>Neotree<CR>";
        key = "<leader>e";
        options = {
          desc = "Explorer Neotree";
          silent = true;
        };
      }
    ];
  };
}

{

  programs.nixvim = {
    plugins.flash = {
      enable = true;
      labels = "asdfghjklqwertyuiopzxcvbnm";
      search = {
        mode = "fuzzy";
      };
      jump = {
        autojump = true;
      };
      label = {
        rainbow = {
          enabled = true;
          shade = 5;
        };
      };
    };
    extraConfigLua = ''
      local opts = { noremap = true, silent = true }
      local keymap = vim.api.nvim_set_keymap
      keymap("n","<c-f>","<cmd>lua require('flash').jump()<cr>",opts)
      keymap("x","<c-f>","<cmd>lua require('flash').jump()<cr>",opts)
      keymap("o","<c-f>","<cmd>lua require('flash').jump()<cr>",opts)
      keymap("n", "<Leader>t", "<cmd>lua require('flash').treesitter()<cr>", opts)
      keymap("o", "<Leader>t", "<cmd>lua require('flash').treesitter()<cr>", opts)
      keymap("x", "<Leader>t", "<cmd>lua require('flash').treesitter()<cr>", opts)
      keymap("o", "<Leader>r", "<cmd>lua require('flash').remote()<cr>", opts)
      keymap("o", "<Leader>T", "<cmd>lua require('flash').treesitter_search()<cr>", opts)
      keymap("x", "<Leader>T", "<cmd>lua require('flash').treesitter_search()<cr>", opts)
    '';
  };
}

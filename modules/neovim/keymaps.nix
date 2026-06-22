_: {
  programs.nvf.settings.vim.keymaps = [
    {
      key = "<leader>m";
      mode = "n";
      silent = true;
      action = ":make<CR>";
    }
    {
      key = "<leader>l";
      mode = [
        "n"
        "x"
      ];
      silent = true;
      action = "<cmd>cnext<CR>";
    }
    {
      key = ";";
      mode = [
        "n"
        "v"
        "x"
        "o"
      ];
      action = ":";
      desc = "Use ; instead of :";
    }
    {
      key = "k";
      mode = "n";
      silent = true;
      expr = true;
      action = "v:count == 0 ? 'gk' : 'k'";
    }
    {
      key = "j";
      mode = "n";
      silent = true;
      expr = true;
      action = "v:count == 0 ? 'gj' : 'j'";
    }
    # Clear search highlight
    {
      key = "<Esc>";
      mode = "n";
      silent = true;
      action = "<CMD>nohlsearch<CR>";
    }
    {
      key = "<leader>q";
      mode = "n";
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
      desc = "Open diagnostic Quickfix list";
    }
    {
      key = "<Esc><Esc>";
      mode = "t";
      action = "<C-\\><C-n>";
      desc = "Exit terminal mode";
    }
    {
      key = "<C-h>";
      mode = "n";
      action = "<C-w><C-h>";
      desc = "Move focus to the left window";
    }
    {
      key = "<C-l>";
      mode = "n";
      action = "<C-w><C-l>";
      desc = "Move focus to the right window";
    }
    {
      key = "<C-j>";
      mode = "n";
      action = "<C-w><C-j>";
      desc = "Move focus to the lower window";
    }
    {
      key = "<C-k>";
      mode = "n";
      action = "<C-w><C-k>";
      desc = "Move focus to the upper window";
    }
  ];
}

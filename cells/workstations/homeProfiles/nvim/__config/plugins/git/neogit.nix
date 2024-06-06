{
  programs.nixvim = {
    plugins.neogit = {
      enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>Neogit<cr>";
        options.silent = true;
      }
    ];
  };
}

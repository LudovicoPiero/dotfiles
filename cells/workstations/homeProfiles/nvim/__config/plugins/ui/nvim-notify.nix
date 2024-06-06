{
  programs.nixvim = {
    plugins.notify = {
      enable = true;
      timeout = 3000;
      backgroundColour = "#000000";
      maxHeight = {
        __raw = "math.floor(vim.o.lines * 0.75)";
      };
      maxWidth = {
        __raw = "math.floor(vim.o.columns * 0.75)";
      };
      onOpen = ''
        function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      '';
    };
  };
}

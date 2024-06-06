{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      registrations = {
        "<leader>c" = "[C]ode";
        "<leader>d" = "[D]ocument";
        "<leader>f" = "[F]ormat";
        "<leader>g" = "[G]it";
        "<leader>h" = "Git [H]unk";
        "<leader>p" = "[P]review";
        "<leader>r" = "[R]ename";
        "<leader>s" = "[S]earch";
        "<leader>t" = "[T]oggle";
        "<leader>w" = "[W]orkspace";
      };
    };
  };
}

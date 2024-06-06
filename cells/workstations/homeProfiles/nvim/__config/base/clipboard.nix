{
  programs.nixvim = {
    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
      };
    };
  };
}

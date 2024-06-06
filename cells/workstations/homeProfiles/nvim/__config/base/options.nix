{

  programs.nixvim = {
    opts = {
      colorcolumn = "80";
      cursorline = true;
      relativenumber = true;
      smartindent = true;
      tabstop = 4;
      shiftwidth = 2;
      shiftround = true;
      expandtab = true;
      scrolloff = 5;
      hlsearch = false;
      number = true;
      mouse = "a";
      breakindent = true;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      inccommand = "split";
      completeopt = "menuone,noselect";
      termguicolors = true;
    };
  };
}

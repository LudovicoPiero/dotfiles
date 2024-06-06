{
  programs.nixvim = {
    plugins.bufferline = {
      enable = true;
      diagnostics = "nvim_lsp";
      offsets = [
        {
          filetype = "CHADTree";
          highlight = "Directory";
          text = "File Explorer";
          text_align = "center";
        }
      ];
    };
  };
}

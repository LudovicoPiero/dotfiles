{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim.languages.zig = {
      enable = true;

      lsp.enable = true;
      treesitter.enable = true;
    };
  };
}

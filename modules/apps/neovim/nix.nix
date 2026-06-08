{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim.languages.nix = {
      enable = true;

      lsp.enable = true;
      treesitter.enable = true;

      extraDiagnostics = {
        enable = true;
        types = [
          "deadnix"
          "statix"
        ];
      };

      format = {
        enable = true;
        type = [ "nixfmt" ];
      };
    };
  };
}

{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim.lsp = {
      enable = true;

      # Show inlay hints (types, parameter names)
      inlayHints.enable = true;

      # Needed for custom LSP configs (vim.lsp.servers)
      lspconfig.enable = true;

      # Light bulb for available code actions
      lightbulb.enable = true;

      # Format on save
      formatOnSave = true;

      mappings = {
        codeAction = "<leader>ca";
        documentHighlight = "<leader>ch";
        format = "<leader>cf";
        goToDeclaration = "<leader>gD";
        goToDefinition = "gd";
        goToType = "<leader>gt";
        hover = "K";
        listImplementations = "<leader>gi";
        listReferences = "<leader>gr";
        nextDiagnostic = "]d";
        previousDiagnostic = "[d";
        renameSymbol = "<leader>rn";
        toggleFormatOnSave = "<leader>tf";
      };
    };
  };
}

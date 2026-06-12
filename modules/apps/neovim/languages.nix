{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      lsp = {
        enable = true;
        inlayHints.enable = true; # Show inlay hints (types, parameter names)
        lspconfig.enable = true;
        lightbulb.enable = true;
        formatOnSave = false;
        lspkind.enable = true; # Show icons in completion menu

        mappings = {
          codeAction = "<leader>ca";
          documentHighlight = "<leader>ch";
          format = "<leader>ff";
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

      languages = {
        enableDAP = true;
        enableExtraDiagnostics = true;
        enableFormat = true;
        enableTreesitter = true;

        # Nix
        nix = {
          enable = true;
          lsp.enable = true;
          format = {
            enable = true;
            type = [ "nixfmt" ];
          };
        };

        # Zig
        zig = {
          enable = true;
          lsp.enable = true;
        };
      };
    };
  };
}

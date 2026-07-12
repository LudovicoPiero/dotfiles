{ config, lib, ... }: {
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      lsp = {
        formatOnSave = false;
        lspkind.enable = false;
        lightbulb.enable = true;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = false;
        otter-nvim.enable = true;
        nvim-docs-view.enable = true;
        presets.harper.enable = true;

        mappings = {
          format = "<leader>ff";
          renameSymbol = "grn";
          codeAction = "gra";
          goToDeclaration = "grD";
          goToDefinition = "grd";
          goToType = "grt";
          hover = "K";
          listImplementations = "gri";
          listReferences = "grr";
          nextDiagnostic = "]d";
          previousDiagnostic = "[d";
          toggleFormatOnSave = "<leader>tf";
        };
      };

      languages = {
        enableExtraDiagnostics = true;
        enableFormat = true;
        enableTreesitter = true;

        # Nix
        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
          format = {
            enable = true;
            type = [ "nixfmt" ];
          };
        };

        markdown.enable = true;
        lua.enable = true;
        bash.enable = true;
        python.enable = true;
        zig.enable = true;
      };
    };
  };
}

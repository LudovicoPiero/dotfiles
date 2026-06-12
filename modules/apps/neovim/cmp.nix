{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      # Auto-close brackets/quotes
      autopairs.nvim-autopairs.enable = true;

      autocomplete.nvim-cmp = {
        enable = true;

        sources = {
          nvim_lsp = "[LSP]";
          luasnip = "[LuaSnip]";
          path = "[Path]";
          buffer = "[Buffer]";
          copilot = "[Copilot]";
          treesitter = "[Treesitter]";
        };

        sourcePlugins = [
          "cmp-buffer"
          "cmp-path"
          "cmp-nvim-lsp"
          "cmp-luasnip"
          "cmp-treesitter"
        ];

        setupOpts = {
          completion.completeopt = "menu,menuone,noselect";
          experimental.ghost_text = true;
        };
      };

      snippets.luasnip = {
        enable = true;
        providers = [ "friendly-snippets" ];
      };

      assistant.copilot = {
        enable = true;
        cmp.enable = true;
        setupOpts = {
          suggestion.enabled = false;
          panel.enabled = false;
        };
      };
    };
  };
}

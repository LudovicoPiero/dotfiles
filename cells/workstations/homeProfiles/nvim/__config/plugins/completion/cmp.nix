{
  programs.nixvim = {
    extraConfigLuaPre = ''
      local luasnip = require("luasnip")
    '';

    plugins = {
      cmp-buffer.enable = true;
      cmp-nvim-lua.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;

      cmp = {
        enable = true;

        autoEnableSources = true;

        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })";
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { 'i', 's' })
            '';
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { 'i', 's' })
            '';
          };

          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lua"; }
            { name = "codeium"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "path"; }
            { name = "emoji"; }
            { name = "cmdli"; }
          ];

          experimental = {
            ghost_text = {
              hl_group = "CmpGhostText";
            };
          };
        };
      };
    };
  };
}

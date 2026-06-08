{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      autocomplete.blink-cmp = {
        enable = true;
        setupOpts = {
          keymap = {
            preset = "default";
            "<C-y>" = [ "select_and_accept" ];
            "<CR>" = [
              (lib.generators.mkLuaInline ''
                function(cmp)
                  if cmp.is_visible() then
                    return cmp.select_and_accept()
                  end
                end
              '')
              "fallback"
            ];
            "<C-e>" = [
              "cancel"
              "fallback"
            ];
            "<C-n>" = [
              "select_next"
              "fallback"
            ];
            "<C-p>" = [
              "select_prev"
              "fallback"
            ];
            "<C-d>" = [
              "scroll_documentation_up"
              "fallback"
            ];
            "<C-f>" = [
              "scroll_documentation_down"
              "fallback"
            ];
            "<Tab>" = [
              "snippet_forward"
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "snippet_backward"
              "select_prev"
              "fallback"
            ];
            "<C-Space>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
          };

          appearance = {
            use_nvim_cmp_as_default = false;
            nerd_font_variant = "normal";
            kind_icons = {
              Copilot = "";
              Text = "󰉿";
              Method = "󰆧";
              Function = "󰊕";
              Constructor = "";
              Field = "󰜢";
              Variable = "󰀫";
              Class = "󰠱";
              Interface = "";
              Module = "";
              Property = "󰜢";
              Unit = "󰑭";
              Value = "󰎠";
              Enum = "";
              Keyword = "󰌋";
              Snippet = "";
              Color = "󰏘";
              File = "󰈙";
              Reference = "󰈇";
              Folder = "󰉋";
              EnumMember = "";
              Constant = "󰏿";
              Struct = "󰙅";
              Event = "";
              Operator = "󰆕";
              TypeParameter = "";
            };
          };

          completion = {
            # Let autopairs handle brackets
            accept.auto_brackets.enabled = false;

            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
              window.border = "rounded";
            };

            menu = {
              border = "rounded";
              draw.columns = [
                [ "kind_icon" ]
                [
                  "label"
                  "label_description"
                ]
                [ "source_name" ]
              ];
            };

            ghost_text.enabled = false;
          };

          signature = {
            enabled = true;
            window.border = "rounded";
          };

          snippets.preset = "luasnip";

          sources = {
            default = [
              # "copilot"
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
            # providers.copilot = {
            #   name = "copilot";
            #   module = "blink-cmp-copilot";
            #   score_offset = 100;
            #   async = true;
            #   transform_items = lib.generators.mkLuaInline ''
            #     function(_, items)
            #       local kinds = require("blink.cmp.types").CompletionItemKind
            #       local idx = #kinds + 1
            #       kinds[idx] = "Copilot"
            #       for _, item in ipairs(items) do
            #         item.kind = idx
            #       end
            #       return items
            #     end
            #   '';
            # };
          };
        };
      };

      snippets.luasnip = {
        enable = true;
        providers = [ "friendly-snippets" ];
      };
    };
  };
}

return {
  { "friendly-snippets" },
  { "LuaSnip" },
  { "lspkind.nvim" },
  { "blink.compat" },
  { "blink-copilot" },
  { "copilot.lua" },

  {
    "blink.cmp",
    event = "DeferredUIEnter",

    before = function()
      require("lz.n").trigger_load("lspkind.nvim")
      require("lz.n").trigger_load("friendly-snippets")
      require("lz.n").trigger_load("LuaSnip")
      require("lz.n").trigger_load("blink.compat")
      require("lz.n").trigger_load("blink-copilot")
    end,

    after = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = false, -- handled by nvim-cmp / blink.cmp
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          gitcommit = true,
          markdown = true,
          help = true,
        },
      })

      require("blink.cmp").setup({
        cmdline = { enabled = false },
        keymap = {
          preset = "enter",
          ["<C-y>"] = { "select_and_accept" },
        },

        appearance = {
          nerd_font_variant = "mono",
          use_nvim_cmp_as_default = true,
          kind_icons = {
            Copilot = "",
          },
        },

        completion = {
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
          ghost_text = { enabled = true },
          menu = {
            auto_show = true,
            border = "rounded",
            draw = {
              treesitter = { "lsp" },
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon", "kind" },
              },
              components = {
                kind_icon = {
                  text = function(ctx)
                    local lspkind = require("lspkind")
                    local icon = ctx.kind_icon
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        icon = dev_icon
                      end
                    else
                      icon = lspkind.symbolic(ctx.kind, {
                        mode = "symbol",
                      })
                    end

                    return icon .. ctx.icon_gap
                  end,

                  -- Optionally, use the highlight groups from nvim-web-devicons
                  -- You can also add the same function for `kind.highlight` if you want to
                  -- keep the highlight groups in sync with the icons.
                  highlight = function(ctx)
                    local hl = ctx.kind_hl
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                      if dev_icon then
                        hl = dev_hl
                      end
                    end
                    return hl
                  end,
                },
              },
            },
          },
        },

        sources = {
          default = { "lsp", "snippets", "buffer", "path", "copilot", "lazydev" },
          providers = {
            lazydev = {
              module = "lazydev.integrations.blink",
              name = "LazyDev",
              score_offset = 100,
            },
            buffer = {
              min_keyword_length = function()
                return vim.bo.filetype == "markdown" and 0 or 1
              end,
            },
            lsp = { score_offset = 4 },
            snippets = {
              score_offset = 4,
              opts = {
                use_show_condition = true,
                show_autosnippets = true,
              },
            },
            path = {
              score_offset = 3,
              opts = {
                trailing_slash = true,
                label_trailing_slash = true,
                get_cwd = function(context)
                  return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
                end,
                show_hidden_files_by_default = false,
              },
            },
            copilot = {
              enabled = true,
              name = "copilot",
              module = "blink-copilot",
              score_offset = 100,
              async = true,
            },
          },
        },

        snippets = { preset = "luasnip" },

        fuzzy = {
          implementation = "rust",
          prebuilt_binaries = {
            download = false,
          },
        },

        signature = {
          enabled = true,
          window = { border = "rounded" },
        },
      })
    end,
  },
}

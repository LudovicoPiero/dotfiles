local blink_pairs = require("blink.pairs")

blink_pairs.setup({
  mappings = {
    enabled = true,
    pairs = {
      ["'"] = {},
    },
  },
  highlights = {
    enabled = true,
    groups = {
      "BlinkPairsOrange",
      "BlinkPairsPurple",
      "BlinkPairsBlue",
    },
    matchparen = {
      enabled = true,
      group = "MatchParen",
    },
  },
  debug = false,
})

vim.keymap.set("n", "<leader>tp", function()
  -- Toggle blink pairs mappings
  vim.g.blink_pairs_disabled = not vim.g.blink_pairs_disabled

  local mappings = require("blink.pairs.mappings")
  if vim.g.blink_pairs_disabled then
    mappings.disable()
  else
    mappings.enable()
  end
end, { desc = "[T]oggle auto [P]airs" })

--- Blink.cmp
-- Load all required modules safely
local lspkind = require("lspkind")
local blink_cmp = require("blink.cmp")
local copilot = require("copilot")

-- Load snippets from VSCode-style snippet sources
require("luasnip.loaders.from_vscode").lazy_load()

-- Setup Copilot
copilot.setup({
  suggestion = {
    enabled = false,
    auto_trigger = true,
    hide_during_completion = true,
    keymap = {
      accept = false, -- handled by blink.cmp
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

-- Setup blink.cmp
blink_cmp.setup({
  cmdline = { enabled = false },

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
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
              end
              return icon .. ctx.icon_gap
            end,

            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local _, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_hl then
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
    default = { "lsp", "snippets", "buffer", "path", "copilot" },
    providers = {
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

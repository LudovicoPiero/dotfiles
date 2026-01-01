-- lua/plugins/utils.lua

-- 1. Treesitter
vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' }, { confirm = false })

-- Safe Load: Treesitter
local ts_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if ts_ok then
  ts_configs.setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "python", "rust", "nix", "markdown", "regex" },
    highlight = { enable = true },
    indent = { enable = true },
  })
end

-- 2. Blink CMP
vim.pack.add({ 'https://github.com/rafamadriz/friendly-snippets' }, { confirm = false })
vim.pack.add({ 'https://github.com/onsails/lspkind.nvim' }, { confirm = false })
vim.pack.add({ 'https://github.com/saghen/blink.cmp' }, { confirm = false })

require("blink.cmp").setup({
  appearance = {
    nerd_font_variant = "mono",
    use_nvim_cmp_as_default = true,
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      snippets = {
        opts = {
          friendly_snippets = true,
          extended_filetypes = {
            markdown = { "jekyll" },
            sh = { "shelldoc" },
            php = { "phpdoc" },
            cpp = { "unreal" },
          },
        },
      },
    },
  },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    prebuilt_binaries = {
      download = true,
      force_version = "v1.8.0",
    }
  },
  signature = { enabled = true },
  completion = {
    list = { selection = { preselect = false } },
    menu = {
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then icon = dev_icon end
              else
                icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
              end
              return icon .. ctx.icon_gap
            end,
          },
        },
      },
    },
  },
  keymap = {
    preset = "none",
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_next()
        elseif cmp.snippet_active() then
          return cmp.snippet_forward()
        else
          return cmp.show()
        end
      end,
      "fallback",
    },
    ["<S-Tab>"] = {
      function(cmp)
        if cmp.is_visible() then
          return cmp.select_prev()
        elseif cmp.snippet_active() then
          return cmp.snippet_backward()
        end
      end,
      "fallback",
    },
  },
})

-- 3. Mini Modules
vim.pack.add({ 'https://github.com/echasnovski/mini.pairs' }, { confirm = false })
require("mini.pairs").setup()

vim.pack.add({ 'https://github.com/echasnovski/mini.ai' }, { confirm = false })
require("mini.ai").setup()

vim.pack.add({ 'https://github.com/echasnovski/mini.surround' }, { confirm = false })
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

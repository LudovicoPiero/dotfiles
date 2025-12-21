-- lua/plugins/lsp.lua

vim.pack.add({ 'https://github.com/williamboman/mason.nvim' }, { confirm = false })
vim.pack.add({ 'https://github.com/williamboman/mason-lspconfig.nvim' }, { confirm = false })
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' }, { confirm = false })

require("mason").setup()
local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
  basedpyright = {
    settings = {
      basedpyright = {
        disableOrganizeImports = true,
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "strict",
          diagnosticSeverityOverrides = {
            reportUnknownParameterType = "warning",
            reportMissingImports = false,
            reportUnusedVariable = "warning",
          },
        },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
    init_options = { usePlaceholders = true },
  },
  emmylua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        diagnostics = { globals = { "vim", "require" } },
      },
    },
  },
  clangd = { capabilities = { offsetEncoding = { "utf-16" } } },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        diagnostics = { enable = true },
      },
    },
  },
}

require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      local server_config = servers[server_name] or {}
      server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
      lspconfig[server_name].setup(server_config)
    end,
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code Action" })
    vim.keymap.set("n", "<leader>cf", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, { buffer = ev.buf, desc = "Format Buffer" })
  end,
})

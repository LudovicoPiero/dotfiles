-- lsp
-- LSP Configuration
local fidget = require("fidget")
local blink_cmp = require("blink.cmp")

-- Initialize fidget (LSP progress indicator)
fidget.setup({})

--------------------------------------------------------------------------------
-- Diagnostic config
--------------------------------------------------------------------------------
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      return diagnostic.message
    end,
  },
})

--------------------------------------------------------------------------------
-- Capabilities
--------------------------------------------------------------------------------
local cmp_capabilities = blink_cmp.get_lsp_capabilities()
local base_cap = vim.lsp.protocol.make_client_capabilities()
local capabilities = vim.tbl_deep_extend("force", base_cap, cmp_capabilities)
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

--------------------------------------------------------------------------------
-- Common on_attach and LspAttach behavior
--------------------------------------------------------------------------------
local diag_float = {}

local function on_attach_common(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Floating diagnostics on CursorHold
  local augroup = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    group = augroup,
    callback = function()
      local line = vim.api.nvim_win_get_cursor(0)[1]

      if diag_float[bufnr] then
        local win = diag_float[bufnr].win
        if win and vim.api.nvim_win_is_valid(win) and diag_float[bufnr].line == line then
          return
        end
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_close(win, true)
        end
      end

      local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
      if vim.tbl_isempty(diagnostics) then
        diag_float[bufnr] = nil
        return
      end

      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "always",
        prefix = " ",
        scope = "line",
      }

      local float_win = vim.diagnostic.open_float(nil, opts)
      if float_win then
        diag_float[bufnr] = { win = float_win, line = line }
      else
        diag_float[bufnr] = nil
      end
    end,
  })

  -- FZF-based LSP keymaps
  local fzf = require("fzf-lua")
  vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "Go to definition", buffer = bufnr })
  vim.keymap.set("n", "gi", fzf.lsp_implementations, { desc = "Go to implementation", buffer = bufnr })
  vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "Find references", buffer = bufnr })
  vim.keymap.set("n", "<leader>ca", fzf.lsp_code_actions, { desc = "[C]ode [A]ctions", buffer = bufnr })
  vim.keymap.set("n", "<leader>D", fzf.lsp_typedefs, { desc = "Go to type definition", buffer = bufnr })
  vim.keymap.set("n", "<leader>sS", vim.lsp.buf.signature_help, { desc = "[S]how [S]ignature", buffer = bufnr })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation", buffer = bufnr })
  vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, { desc = "Rename symbol", buffer = bufnr })
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "Prev diagnostic", buffer = bufnr })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = "Next diagnostic", buffer = bufnr })
end

--------------------------------------------------------------------------------
-- Server setup helper
--------------------------------------------------------------------------------
local function common(name, settings)
  vim.lsp.config(
    name,
    vim.tbl_deep_extend("force", {
      on_attach = on_attach_common,
      capabilities = capabilities,
    }, settings or {})
  )
end

-- Server configurations
common("nixd", {
  settings = {
    nixd = {
      formatting = { command = { "nixfmt" } },
      nixpkgs = { expr = "import <nixpkgs> { }" },
    },
  },
})

common("gopls", {
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
  init_options = { usePlaceholders = true },
})

common("basedpyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "off",
      },
    },
  },
})

common("emmylua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
})

common("rust_analyzer", {
  on_attach = function(client, bufnr)
    on_attach_common(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
      end,
    })
  end,
  settings = {
    ["rust-analyzer"] = {
      diagnostics = { enable = true },
      files = { excludeDirs = { ".direnv", "rust/.direnv" } },
    },
  },
})

for _, s in ipairs({
  "taplo",
  "html",
  "cssls",
  "ts_ls",
  "bashls",
  "hls",
  "clangd",
  "cmake",
  "mesonlsp",
}) do
  common(s)
end

-- clangd special case
vim.lsp.config("clangd", {
  on_attach = on_attach_common,
  capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
})

-- Finally enable all configured servers
for _, s in ipairs({
  "nixd",
  "gopls",
  "basedpyright",
  "emmylua_ls",
  "rust_analyzer",
  "taplo",
  "html",
  "cssls",
  "ts_ls",
  "bashls",
  "hls",
  "clangd",
  "cmake",
  "mesonlsp",
}) do
  vim.lsp.enable(s)
end

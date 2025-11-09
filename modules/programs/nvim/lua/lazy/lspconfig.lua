return {
  { "fidget.nvim" },
  { "fzf-lua" },
  { "blink.cmp" },
  {
    "nvim-lspconfig",
    lazy = false,
    before = function()
      LZN.trigger_load("fidget.nvim")
      LZN.trigger_load("fzf-lua")
      LZN.trigger_load("blink.cmp")
    end,
    after = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- highlight references
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev.buf })
              end,
            })
          end

          -- toggle inlay hints
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- =========================================================
      -- Diagnostic config
      -- =========================================================
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

      -- =========================================================
      -- Capabilities
      -- =========================================================
      local cmp_capabilities = require("blink.cmp").get_lsp_capabilities()
      local base_cap = vim.lsp.protocol.make_client_capabilities()
      local capabilities = vim.tbl_deep_extend("force", base_cap, cmp_capabilities)
      capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

      local diag_float = {}
      local on_attach_common = function(client, bufnr)
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

        local opts = { noremap = true, silent = true, buffer = bufnr }
        local fzf = require("fzf-lua")
        vim.keymap.set("n", "gd", fzf.lsp_definitions, vim.tbl_extend("force", { desc = "Go to definition" }, opts))
        vim.keymap.set(
          "n",
          "gi",
          fzf.lsp_implementations,
          vim.tbl_extend("force", { desc = "Go to implementation" }, opts)
        )
        vim.keymap.set("n", "gr", fzf.lsp_references, vim.tbl_extend("force", { desc = "Find references" }, opts))
        vim.keymap.set(
          "n",
          "<leader>ca",
          fzf.lsp_code_actions,
          vim.tbl_extend("force", { desc = "[C]ode [A]ctions" }, opts)
        )
        vim.keymap.set(
          "n",
          "<leader>D",
          fzf.lsp_typedefs,
          vim.tbl_extend("force", { desc = "Go to type definition" }, opts)
        )
        vim.keymap.set("n", "<leader>st", function()
          require("todo-comments.fzf").todo()
        end, vim.tbl_extend("force", { desc = "[S]earch [T]odo" }, opts))
        vim.keymap.set("n", "<leader>sT", function()
          require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
        end, vim.tbl_extend("force", { desc = "[S]earch [T]odo and FIXME" }, opts))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", { desc = "Hover documentation" }, opts))
        vim.keymap.set(
          "n",
          "<leader>sS",
          vim.lsp.buf.signature_help,
          vim.tbl_extend("force", { desc = "[S]how [S]ignature help" }, opts)
        )
        vim.keymap.set("n", "<leader>n", vim.lsp.buf.rename, vim.tbl_extend("force", { desc = "Rename symbol" }, opts))
        vim.keymap.set("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, vim.tbl_extend("force", { desc = "Prev diagnostic" }, opts))
        vim.keymap.set("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, vim.tbl_extend("force", { desc = "Next diagnostic" }, opts))
        vim.keymap.set("n", "<leader>L", function()
          print(vim.inspect(vim.lsp.get_clients({ bufnr = bufnr })))
        end, vim.tbl_extend("force", { desc = "List LSP clients" }, opts))
      end

      -- =========================================================
      -- Server configurations
      -- =========================================================
      local function common(name, settings)
        vim.lsp.config(
          name,
          vim.tbl_deep_extend("force", {
            on_attach = on_attach_common,
            capabilities = capabilities,
          }, settings or {})
        )
      end

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
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
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
            diagnostics = { enable = true, styleLints = { enable = true } },
            files = { excludeDirs = { ".direnv", "rust/.direnv" } },
            inlayHints = {
              bindingModeHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              discriminantHints = { enable = "always" },
              expressionAdjustmentHints = { enable = "always" },
              lifetimeElisionHints = { enable = "always" },
              rangeExclusiveHints = { enable = true },
            },
            procMacro = { enable = true },
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

      vim.lsp.config("clangd", {
        on_attach = on_attach_common,
        capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
      })

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
    end,
  },
}

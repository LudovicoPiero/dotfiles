return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 1. UI Configuration
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        severity_sort = true,
      })
      -- vim.diagnostic.config({
      --   severity_sort = true,
      --   update_in_insert = false,
      --   float = { border = "rounded", source = "if_many" },
      --   underline = { severity = vim.diagnostic.severity.ERROR },
      --   signs = {
      --     text = {
      --       [vim.diagnostic.severity.ERROR] = "󰅚 ",
      --       [vim.diagnostic.severity.WARN] = "󰀪 ",
      --       [vim.diagnostic.severity.INFO] = "󰋽 ",
      --       [vim.diagnostic.severity.HINT] = "󰌶 ",
      --     },
      --   },
      -- })

      vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("LspDiagnosticsFloat", { clear = true }),
        callback = function()
          vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "cursor",
          })
        end,
      })

      -- 2. Keybindings (LspAttach)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = desc })
          end

          map("gd", function()
            Snacks.picker.lsp_definitions()
          end, "Go to Definition")
          map("gD", function()
            Snacks.picker.lsp_declarations()
          end, "Go to Declaration")
          map("grr", function()
            Snacks.picker.lsp_references()
          end, "Find References")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Actions")
          map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")

          if client and client.server_capabilities.inlayHintProvider then
            map("<leader>th", function()
              local current = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
              vim.lsp.inlay_hint.enable(not current, { bufnr = ev.buf })
            end, "Toggle Inlay Hints")
          end
        end,
      })

      -- 3. Servers
      local servers = {
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true, -- Let Ruff handle this
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "strict",

                diagnosticSeverityOverrides = {
                  -- Downgrade some errors to warnings.
                  reportUnknownParameterType = "warning",
                  reportMissingParameterType = "warning",
                  reportUnknownArgumentType = "warning",
                  reportUnknownLambdaType = "warning",
                  reportUnknownMemberType = "warning",
                  reportUntypedFunctionDecorator = "warning",
                  reportDeprecated = "warning",

                  -- Restore unused warnings.
                  reportUnusedFunction = "warning",
                  reportUnusedVariable = "warning",

                  -- Enable extra checks.
                  reportUnusedCallResult = "warning",
                  reportUninitializedInstanceVariable = "warning",

                  -- Silence noise for new projects.
                  reportMissingImports = false,
                  reportMissingTypeStubs = false, -- Very important for libraries
                  reportUnknownVariableType = false,

                  -- Let ruff handle imports.
                  reportUnusedImport = "warning",
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
              diagnostics = { globals = { "vim" } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            },
          },
        },
        clangd = {
          capabilities = vim.tbl_deep_extend("force", vim.deepcopy(capabilities), {
            offsetEncoding = { "utf-16" },
          }),
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              diagnostics = { enable = true },
              files = { excludeDirs = { ".direnv", "rust/.direnv" } },
            },
          },
        },
        nil_ls = {
          cmd = { "nil" },
          filetypes = { "nix" },
          root_markers = { "flake.nix", "default.nix", ".git" },
          settings = {
            ["nil"] = {
              nix = {
                flake = {
                  autoArchive = true,
                },
              },
            },
          },
        },
      }

      -- 4. Setup Logic
      local function setup_server(server_name, config)
        config = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, config or {})

        vim.lsp.config[server_name] = vim.tbl_deep_extend("force", vim.lsp.config[server_name] or {}, config)
        vim.lsp.enable(server_name)
      end

      require("mason").setup()
      local mason_lspconfig = require("mason-lspconfig")
      local system_servers = { "clangd", "rust_analyzer", "nil_ls" }

      local ensure_installed = vim.tbl_keys(servers)
      for i, server in ipairs(ensure_installed) do
        if vim.tbl_contains(system_servers, server) then
          table.remove(ensure_installed, i)
        end
      end

      mason_lspconfig.setup({
        ensure_installed = ensure_installed,
        handlers = {
          function(server_name)
            if vim.tbl_contains(system_servers, server_name) then
              return
            end
            setup_server(server_name, servers[server_name])
          end,
        },
      })

      for _, server_name in ipairs(system_servers) do
        local binary_name = (server_name:gsub("_", "-"))

        if vim.fn.executable(server_name) == 1 or vim.fn.executable(binary_name) == 1 then
          setup_server(server_name, servers[server_name])
        end
      end
    end,
  },
}

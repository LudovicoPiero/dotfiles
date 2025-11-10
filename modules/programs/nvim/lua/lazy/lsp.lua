---@diagnostic disable: undefined-global
return {
  { "fidget.nvim" },
  { "nvim-web-devicons" },
  { "blink.cmp" },
  {
    "nvim-lspconfig",
    event = "DeferredUIEnter", -- This is equivalent to lazy.nvim's VeryLazy event
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },

    before = function()
      require("lz.n").trigger_load("fzf-lua")
      require("lz.n").trigger_load("fidget.nvim")
      require("lz.n").trigger_load("nvim-web-devicons")
    end,

    after = function()
      require("fidget").setup({})

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nvim-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map("gra", function()
            FzfLua.lsp_code_actions()
          end, "[G]oto Code [A]ction", { "n", "x" })

          -- Find references for the word under your cursor.
          map("grr", function()
            FzfLua.lsp_definitions()
          end, "[G]oto [R]eferences")

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map("gri", function()
            FzfLua.lsp_implementations()
          end, "[G]oto [I]mplementation")

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map("grd", function()
            FzfLua.lsp_definitions()
          end, "[G]oto [D]efinition")

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map("grD", function()
            FzfLua.declarations()
          end, "[G]oto [D]eclaration")

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map("gO", function()
            FzfLua.lsp_document_symbols()
          end, "Open Document Symbols")

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map("gW", function()
            FzfLua.lsp_workspace_symbols()
          end, "Open Workspace Symbols")

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map("grt", function()
            FzfLua.lsp_typedefs()
          end, "[G]oto [T]ype Definition")

          -- Toggle to show/hide diagnostic messages
          map("<leader>td", function()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
          end, "[T]oggle [D]iagnostics")

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("nvim-lsp-highlight", { clear = false })
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
              group = vim.api.nvim_create_augroup("nvim-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "nvim-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        signs = {
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
        },
      })

      local cmp_capabilities = require("blink.cmp").get_lsp_capabilities()
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = vim.tbl_deep_extend("force", lsp_capabilities, cmp_capabilities)
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      vim.lsp.config("nixd", {
        cmd = { "nixd" },
        capabilities = capabilities,
        settings = {
          nixd = {
            formatting = {
              command = { "nixfmt" },
            },
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake "/home/airi/Code/nvim-flake").nixosConfigurations.sforza.options',
              },
              ["home-manager"] = {
                expr = '(builtins.getFlake "/home/airi/Code/nvim-flake").homeConfigurations."airi@sforza".options',
              },
            },
          },
        },
      })

      vim.lsp.config("gopls", {
        cmd = { "gopls" },
        capabilities = capabilities,
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

      vim.lsp.config("basedpyright", {
        cmd = { "basedpyright-langserver", "--stdio" },
        capabilities = capabilities,
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

      vim.lsp.config("emmylua_ls", {
        cmd = { "emmylua_ls" },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        cmd = { "rust-analyzer" },
        capabilities = capabilities,
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

      vim.lsp.config("taplo", {
        cmd = { "taplo", "lsp", "stdio" },
        capabilities = capabilities,
      })

      vim.lsp.config("html", {
        cmd = { "vscode-html-language-server", "--stdio" },
        capabilities = capabilities,
      })

      vim.lsp.config("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        capabilities = capabilities,
      })

      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        capabilities = capabilities,
      })

      vim.lsp.config("vue_ls", {
        cmd = { "vue-language-server", "--stdio" },
        capabilities = capabilities,
      })

      vim.lsp.config("bashls", {
        cmd = { "bash-language-server", "start" },
        capabilities = capabilities,
      })

      vim.lsp.config("hls", {
        cmd = { "haskell-language-server-wrapper", "--lsp" },
        capabilities = capabilities,
      })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--enable-config",
          "--pch-storage=memory",
          "--compile-commands-dir=''${workspaceFolder}/build",
          "--background-index",
          "--clang-tidy",
          "--log=verbose",
          "--all-scopes-completion",
          "--header-insertion=iwyu",
          "--fallback-style=LLVM",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--pretty",
        },
        capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
      })

      vim.lsp.config("cmake", {
        cmd = { "cmake-language-server" },
        capabilities = capabilities,
      })

      vim.lsp.config("mesonlsp", {
        cmd = { "mesonlsp", "--lsp" },
        capabilities = capabilities,
      })

      vim.lsp.config("yamlls", {
        cmd = { "yaml-language-server", "--stdio" },
        capabilities = capabilities,
      })

      vim.lsp.config("marksman", {
        cmd = { "marksman", "server" },
        capabilities = capabilities,
      })

      vim.lsp.config("jsonls", {
        cmd = { "vscode-json-language-server", "--stdio" },
        capabilities = capabilities,
      })

      -- ---------------------
      -- Enable all configured servers
      -- ---------------------
      local servers = {
        "nixd",
        "gopls",
        "basedpyright",
        "lua_ls",
        "rust_analyzer",
        "taplo",
        "html",
        "cssls",
        "ts_ls",
        "vue_ls",
        "bashls",
        "hls",
        "clangd",
        "cmake",
        "mesonlsp",
        "yamlls",
        "marksman",
        "jsonls",
      }

      for _, s in ipairs(servers) do
        vim.lsp.enable(s)
      end
    end,
  },

  {
    "fzf-lua",
    event = { "DeferredUIEnter" },
    after = function()
      require("fzf-lua").setup({
        fzf_opts = {
          ["--layout"] = "default",
        },
        winopts = {
          preview = {
            vertical = "up:50%",
            horizontal = "right:50%",
            delay = 10,
          },
        },
      })

      -- Use fzf-lua for vim.ui.select
      require("fzf-lua").register_ui_select()
    end,

    keys = {
      {
        "<leader>sq",
        function()
          FzfLua.quickfix()
        end,
        desc = "[S]earch [Q]uickfix List",
      },
      {
        "<leader>sh",
        function()
          FzfLua.helptags()
        end,
        desc = "[S]earch [H]elp",
      },
      {
        "<leader>sk",
        function()
          FzfLua.keymaps()
        end,
        desc = "[S]earch [K]eymaps",
      },
      {
        "<leader>sf",
        function()
          FzfLua.files()
        end,
        desc = "[S]earch [F]iles",
      },
      {
        "<leader>sb",
        function()
          FzfLua.builtin()
        end,
        desc = "[S]earch [B]uiltin FzfLua",
      },
      {
        "<leader>sw",
        function()
          FzfLua.grep_cword()
        end,
        desc = "[S]earch current [W]ord",
      },
      {
        "<leader>sg",
        function()
          FzfLua.live_grep()
        end,
        desc = "[S]earch by [G]rep",
      },
      {
        "<leader>sd",
        function()
          FzfLua.diagnostics_document()
        end,
        desc = "[S]earch [d]iagnostic documents",
      },
      {
        "<leader>sD",
        function()
          FzfLua.diagnostics_workspace()
        end,
        desc = "[S]earch [D]iagnostic workspace",
      },
      {
        "<leader>s.",
        function()
          FzfLua.oldfiles()
        end,
        desc = "[S]earch Recent Files ('.' for repeat)",
      },
      {
        "<leader><leader>",
        function()
          FzfLua.buffers()
        end,
        desc = "[ ] Find existing buffers",
      },
      {
        "<leader>/",
        function()
          FzfLua.lgrep_curbuf()
        end,
        desc = "[S]earch [/] in Open Files",
      },
    },
  },
}

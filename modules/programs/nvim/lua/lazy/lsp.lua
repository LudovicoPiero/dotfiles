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
      require("lz.n").trigger_load("blink.cmp")
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

      local servers = {
        nixd = {
          cmd = { "nixd", "--inlay-hints=true", "--semantic-tokens=true" },
          settings = {
            nixd = {
              nixpkgs = {
                expr = "import <nixpkgs> { }",
              },
              formatting = {
                command = { "nixfmt" },
              },
              options = {
                nixos = {
                  expr = '(builtins.getFlake "/home/airi/Code/nvim-flake").nixosConfigurations.sforza.options',
                },
                home_manager = {
                  expr = '(builtins.getFlake "/home/airi/Code/nvim-flake").homeConfigurations."airi@sforza".options',
                },
              },
            },
          },
        },
        gopls = { cmd = { "gopls" } },
        basedpyright = { cmd = { "basedpyright-langserver", "--stdio" } },
        rust_analyzer = { cmd = { "rust-analyzer" } },
        clangd = { cmd = { "clangd" } },
        mesonlsp = { cmd = { "mesonlsp", "--lsp" } },
        bashls = { cmd = { "bash-language-server", "start" } },
        ts_ls = { cmd = { "typescript-language-server", "--stdio" } },
        hls = { cmd = { "haskell-language-server-wrapper", "--lsp" } },
        taplo = { cmd = { "taplo", "lsp", "stdio" } },
        cssls = { cmd = { "vscode-css-language-server", "--stdio" } },
        yamlls = { cmd = { "yaml-language-server", "--stdio" } },
        marksman = { cmd = { "marksman", "server" } },
        emmylua_ls = {
          filetypes = { "lua" },
          cmd = { "emmylua_ls" },
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
            },
          },
        },
      }

      -- Register and enable each server
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      for name, config in pairs(servers) do
        local existing = nil
        local ok, configs = pcall(require, "lspconfig.configs")
        if ok then
          existing = configs[name]
        end

        if existing then
          config = vim.tbl_deep_extend("force", vim.deepcopy(existing.default_config or {}), config)
        end

        config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})

        if vim.fn.executable(config.cmd and config.cmd[1] or name) == 1 then
          vim.lsp.config(name, config)
          vim.lsp.enable(name)
        else
          vim.notify(("LSP: %s not found in PATH, skipping"):format(name), vim.log.levels.WARN)
        end
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

--- @diagnostic disable: param-type-not-match, undefined-global, type-not-found

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
  defaults = {
    lazy = true, -- Set global lazy loading
  },
  rtp = {
    reset = true,
    paths = {},
    disabled_plugins = {
      "gzip",
      "matchit",
      "rplugin",
      "tarPlugin",
      "tohtml",
      "tutor",
      "zipPlugin",
    },
  },
  rocks = {
    hererocks = false,
    enabled = false,
  },
  "NMAC427/guess-indent.nvim", -- Detect tabstop and shiftwidth automatically
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = "<Up> ",
          Down = "<Down> ",
          Left = "<Left> ",
          Right = "<Right> ",
          C = "<C-…> ",
          M = "<M-…> ",
          D = "<D-…> ",
          S = "<S-…> ",
          CR = "<CR> ",
          Esc = "<Esc> ",
          ScrollWheelDown = "<ScrollWheelDown> ",
          ScrollWheelUp = "<ScrollWheelUp> ",
          NL = "<NL> ",
          BS = "<BS> ",
          Space = "<Space> ",
          Tab = "<Tab> ",
          F1 = "<F1>",
          F2 = "<F2>",
          F3 = "<F3>",
          F4 = "<F4>",
          F5 = "<F5>",
          F6 = "<F6>",
          F7 = "<F7>",
          F8 = "<F8>",
          F9 = "<F9>",
          F10 = "<F10>",
          F11 = "<F11>",
          F12 = "<F12>",
        },
      },

      -- Document existing key chains
      spec = {
        { "<leader>b", group = "[B]uffers", mode = { "n", "x" } },
        { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>f", group = "[F]ormat" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
        { "<leader>x", group = "Quickfi[X]", mode = { "n", "v" } },
      },
    },
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("fzf-lua").setup({
        {
          "max-perf",
          "ivy",
        },
        winopts = {
          preview = {
            default = "bat",
          },
        },
      })

      local fzf = require("fzf-lua")
      vim.keymap.set("n", "<leader>sq", fzf.quickfix, { desc = "[S]earch [Q]uickfix List" })
      vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>sb", fzf.builtin, { desc = "[S]earch [B]uiltin FzfLua" })
      vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "[S]earch [d]iagnostic documents" })
      vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "[S]earch [D]iagnostic workspace" })
      vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
      vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "[S]earch [/] in Open Files" })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "j-hui/fidget.nvim", opts = {} },
      {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
      },
      "saghen/blink.cmp",
    },
    config = function()
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

            -- Check if we have a valid float already for this line
            if diag_float[bufnr] then
              local win = diag_float[bufnr].win
              if win and vim.api.nvim_win_is_valid(win) and diag_float[bufnr].line == line then
                return
              end
              -- Close old float if it exists
              if win and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
              end
            end

            -- Only open float if there are diagnostics on this line
            local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
            if vim.tbl_isempty(diagnostics) then
              diag_float[bufnr] = nil
              return
            end

            -- Diagnostic options
            local opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = "rounded",
              source = "always",
              prefix = " ",
              scope = "line",
            }

            local float_win = vim.diagnostic.open_float(nil, opts)

            -- Track the float window and the line it is for
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

      -- Special case: clangd offsetEncoding
      vim.lsp.config("clangd", {
        on_attach = on_attach_common,
        capabilities = vim.tbl_deep_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
      })

      -- Enable all configured servers
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

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>ff",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback", -- use LSP first, then fall back to formatter
          })
        end,
        mode = "",
        desc = "[F]ormat bu[F]fer",
      },
    },
    opts = {
      notify_on_error = false,

      formatters_by_ft = {
        -- === Core languages ===
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format" },
        nix = { "nixfmt" },
        sh = { "shellcheck", "shellharden", "shfmt" },
        bash = { "shellcheck", "shellharden", "shfmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
        cmake = { "cmake_format" },
        gn = { "gn" },

        -- === Web / data ===
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        toml = { "taplo" },
      },

      formatters = {
        -- Lua
        stylua = {
          command = "stylua",
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },

        -- Python
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },
        ruff_fix = {
          command = "ruff",
          args = { "check", "--fix", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
        },

        -- C / C++
        clang_format = {
          command = "clang-format",
        },

        -- CMake
        cmake_format = {
          command = "cmake-format",
        },

        -- Go
        gofumpt = {
          command = "gofumpt",
        },
        goimports = {
          command = "goimports",
        },

        -- Nix
        nixfmt = {
          command = "nixfmt",
          prepend_args = { "--strict" },
        },

        -- Shell
        shfmt = {
          command = "shfmt",
          prepend_args = { "-i", "2", "-ci" },
        },
        shellcheck = {
          command = "shellcheck",
        },
        shellharden = {
          command = "shellharden",
        },

        -- Web / data
        prettier = {
          command = "prettier",
        },
        taplo = {
          command = "taplo",
          args = { "format", "-" },
          stdin = true,
        },

        -- Rust
        rustfmt = {
          command = "rustfmt",
        },

        -- Misc
        gn = {
          command = "gn",
        },
      },
    },
  },

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },

  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.splitjoin").setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup({
        mappings = {
          add = "gsa", -- Add surrounding in Normal and Visual modes
          delete = "gsd", -- Delete surrounding
          find = "gsf", -- Find surrounding (to the right)
          find_left = "gsF", -- Find surrounding (to the left)
          highlight = "gsh", -- Highlight surrounding
          replace = "gsr", -- Replace surrounding
          update_n_lines = "gsn", -- Update `n_lines`
        },
      })

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require("mini.statusline")
      -- set use_icons to true if you have a Nerd Font
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      vim.keymap.set("n", "<leader>bd", function()
        local bd = require("mini.bufremove").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then -- Yes
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then -- No
            bd(0, true)
          end
        else
          bd(0)
        end
      end, { desc = "Delete Buffer" })

      vim.keymap.set("n", "<leader>bD", function()
        require("mini.bufremove").delete(0, true)
      end, { desc = "Delete Buffer (Force)" })

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
      },
      -- Autoinstall languages that are not installed
      auto_install = false, -- Installed via nix
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
  },

  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        opts = {},
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
      { "onsails/lspkind.nvim", opts = {} },
      { "saghen/blink.compat", opts = {} },
      { "fang2hou/blink-copilot" },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        opts = {
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
        },
      },
    },
    opts = {
      cmdline = { enabled = false },
      -- keymap = {
      -- 	preset = "enter",
      -- 	["<C-y>"] = { "select_and_accept" },
      -- },

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
        implementation = "lua", -- TODO: Use rust
        prebuilt_binaries = {
          download = false,
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
    },
  },

  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>tf",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>tc",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>tt",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      -- stylua: ignore start
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      -- stylua: ignore end
    },
  },

  --- UI ---
  {
    "akinsho/bufferline.nvim",
    init = function()
      vim.keymap.set("n", "<Tab>", ":BufferLinePick<CR>", { silent = true })
      -- vim.keymap.set("n", "<Tab>", ":bnext<CR>", { silent = true })
      -- vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", { silent = true })
    end,
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        -- highlights = require("catppuccin.special.bufferline").get_theme(),
        options = {
          show_close_icon = false,
          show_buffer_close_icons = false,
          separator_style = "thin",
          diagnostics = "nvim_lsp",
          themable = true,
          pick = {
            alphabet = "abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ1234567890",
          },
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup({ indent = { highlight = highlight } })
    end,
  },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("tokyonight").setup({
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      })

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme("tokyonight-storm")
    end,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

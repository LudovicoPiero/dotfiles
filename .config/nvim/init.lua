---@diagnostic disable: undefined-global
-- Global settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Options
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.showmode = false
opt.scrolloff = 10
opt.colorcolumn = "80,100"
opt.laststatus = 3
opt.winborder = "rounded"

-- Modern features
opt.smoothscroll = true
opt.splitkeep = "screen"

-- Cursor and input
opt.mouse = "a"
opt.guicursor = "n-v-i-c:block-Cursor"
opt.timeoutlen = 300

-- Indentation
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- File and undo
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.exrc = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Visual characters
opt.fillchars = {
  eob = " ",
  vert = "│",
  fold = " ",
  diff = "╱",
}

opt.list = true
opt.listchars = {
  tab = "  ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "␣",
}

-- Plugins
require("lazy").setup({
  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- File Explorer
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        view_options = { show_hidden = true },
      })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })
    end,
  },

  -- Keybinding Helper
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>c", group = "Code" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Search" },
        { "<leader>b", group = "Buffer" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Modern QOL Utils (Replaces dashboard, notify, etc.)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      scroll = { enabled = false },
      bigfile = { enabled = true },
      image = { doc = { enabled = false } },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = { ui_select = true },
      bufdelete = { enabled = true },
      indent = { enabled = true, indent = { char = "▏" }, scope = { char = "▏" }, animate = { enabled = false } },
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "projects", gap = 0.5, padding = 0.5 },
          { section = "recent_files", gap = 0.5, padding = 0.5 },
        },
        preset = {
          header = [[
        ███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗
        ████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝
        ██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗
        ██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║
        ██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║
        ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
        ]],
        },
      },
    },
    keys = {
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>rf",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit()
        end,
        desc = "LazyGit",
      },
      {
        "<leader>sf",
        function()
          Snacks.picker.files({ matcher = { frecency = true, history_bonus = true, ignorecase = false } })
        end,
        desc = "Search Files",
      },
      {
        "<leader>s.",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent Files",
      },
      {
        "<leader><leader>",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Live Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Grep Current Word",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.lines()
        end,
        desc = "Grep Buffer",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Document Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.pickers()
        end,
        desc = "Snacks Pickers",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Search Help",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Search Keymaps",
      },
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments()
        end,
        desc = "Search Todos",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Search specific Todos",
      },
    },
  },

  -- Navigation / Motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
    },
  },

  -- Treesitter (Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "python", "rust", "nix", "markdown" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Completion (Blink - Faster than CMP)
  {
    "saghen/blink.cmp",
    version = "v0.*",
    opts = {
      completion = { trigger = { show_in_snippet = false } },
      keymap = { preset = "super-tab" },
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = true,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- LSP Support
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
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
                  reportMissingParameterType = "warning",
                  reportUnknownArgumentType = "warning",
                  reportUnknownLambdaType = "warning",
                  reportUnknownMemberType = "warning",
                  reportUntypedFunctionDecorator = "warning",
                  reportDeprecated = "warning",
                  reportUnusedFunction = "warning",
                  reportUnusedVariable = "warning",
                  reportUnusedCallResult = "warning",
                  reportUninitializedInstanceVariable = "warning",
                  reportMissingImports = false,
                  reportMissingTypeStubs = false,
                  reportUnknownVariableType = false,
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
          capabilities = {
            offsetEncoding = { "utf-16" }, -- Vital for avoiding clangd indexing crashes
          },
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
        -- nil_ls = {
        --   filetypes = { "nix" },
        --   root_markers = { "flake.nix", "default.nix", ".git" },
        --   settings = {
        --     ["nil"] = {
        --       nix = {
        --         flake = {
        --           autoArchive = true,
        --         },
        --       },
        --     },
        --   },
        -- },
      }

      -- Mason Handlers
      -- This function runs for EVERY server Mason sets up.
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            local server_config = servers[server_name] or {}

            -- Merge default capabilities with your server-specific capabilities
            -- This ensures 'offsetEncoding' in clangd doesn't get wiped out by blink.cmp
            server_config.capabilities =
              vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})

            lspconfig[server_name].setup(server_config)
          end,
        },
      })

      -- Keybinds
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
    end,
  },

  -- Formatting (Conform)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>F",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
        nix = { "nixfmt" },
        go = { "gofumpt", "goimports" },
        rust = { "rustfmt" },
        sh = { "shellharden", "shfmt" },
        bash = { "shellharden", "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        cmake = { "cmake_format" },
        toml = { "taplo" },
        gn = { "gn" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
      formatters = {
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
        nixfmt = { prepend_args = { "--strict", "--width=80" } },
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
  },

  -- Git Signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
    },
  },

  -- Bufferline (Tabs)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        separator_style = "thin",
        diagnostics = "nvim_lsp",
      },
    },
    keys = {
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
  },

  -- Autopairs
  {
    "nvim-mini/mini.pairs",
    version = false,
    config = function()
      require("mini.pairs").setup()
    end,
  },

  -- Mini.ai
  {
    "nvim-mini/mini.ai",
    version = false,
    config = function()
      require("mini.ai").setup()
    end,
  },

  -- CSS Colors
  {
    "brenoprata10/nvim-highlight-colors",
    opts = {
      render = "background",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },
})

-- Autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("lain_" .. name, { clear = true })
end
-- Close certain filetypes with 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "qf",
    "man",
    "notify",
    "checkhealth",
    "lspinfo",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
    "gitsigns.blame",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})

-- Create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("help_split"),
  pattern = "help",
  command = "wincmd L",
})

-- Trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "markdown" or vim.bo.binary then
      return
    end
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Resize splits on window resize
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

return {
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
}

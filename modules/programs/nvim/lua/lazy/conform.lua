return {
  {
    "conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    before = function()
      vim.keymap.set("", "<leader>ff", function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
        })
      end, { desc = "[F]ormat bu[F]fer" })
    end,
    after = function()
      require("conform").setup({
        notify_on_error = false,

        formatters_by_ft = {
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
          stylua = {
            command = "stylua",
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
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
          clang_format = { command = "clang-format" },
          cmake_format = { command = "cmake-format" },
          gofumpt = { command = "gofumpt" },
          goimports = { command = "goimports" },
          nixfmt = { command = "nixfmt", prepend_args = { "--strict" } },
          shfmt = { command = "shfmt", prepend_args = { "-i", "2", "-ci" } },
          shellcheck = { command = "shellcheck" },
          shellharden = { command = "shellharden" },
          prettier = { command = "prettier" },
          taplo = { command = "taplo", args = { "format", "-" }, stdin = true },
          rustfmt = { command = "rustfmt" },
          gn = { command = "gn" },
        },
      })
    end,
  },
}

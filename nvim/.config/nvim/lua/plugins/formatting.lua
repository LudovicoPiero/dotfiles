-- lua/plugins/formatting.lua

vim.pack.add({ 'https://github.com/stevearc/conform.nvim' }, { confirm = false })

require("conform").setup({
  notify_on_error = false,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
    nix = { "nixfmt" },
    go = { "gofumpt", "goimports" },
    rust = { "rustfmt" },
    sh = { "shellharden", "shfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
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
})

vim.keymap.set("", "<leader>F", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

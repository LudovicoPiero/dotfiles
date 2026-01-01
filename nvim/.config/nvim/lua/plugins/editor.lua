-- lua/plugins/editor.lua

-- 1. Oil
vim.pack.add({ 'https://github.com/stevearc/oil.nvim' }, { confirm = false })
require("oil").setup({
  view_options = { show_hidden = true },
  default_file_explorer = true,
  columns = { "permissions", "mtime", "size", "icon" },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })

-- 2. Which-Key
vim.pack.add({ 'https://github.com/folke/which-key.nvim' }, { confirm = false })
require("which-key").setup({
  preset = "modern",
  spec = {
    { "<leader>c", group = "Code" },
    { "<leader>g", group = "Git" },
    { "<leader>s", group = "Search" },
    { "<leader>b", group = "Buffer" },
  },
})
vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end,
  { desc = "Buffer Local Keymaps" })

-- 3. Snacks.nvim
vim.pack.add({ 'https://github.com/folke/snacks.nvim' }, { confirm = false })
local Snacks = require("snacks")
Snacks.setup({
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
      { section = "keys",         gap = 1,   padding = 1 },
      { section = "projects",     gap = 0.5, padding = 0.5 },
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
})

-- Snacks Keymaps
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>rf", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>sf",
  function() Snacks.picker.files({ matcher = { frecency = true, history_bonus = true, ignorecase = false } }) end,
  { desc = "Search Files" })
vim.keymap.set("n", "<leader>s.", function() Snacks.picker.recent() end, { desc = "Recent Files" })
vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.buffers() end, { desc = "Open Buffers" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Search Help" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Grep Current Word" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end, { desc = "Grep Buffer" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics() end, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })

-- 4. Flash
vim.pack.add({ 'https://github.com/folke/flash.nvim' }, { confirm = false })
require("flash").setup({
  modes = { char = { keys = { "f", "F", "t", "T", "," } } },
})
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

-- 5. Gitsigns
vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' }, { confirm = false })
require("gitsigns").setup({ current_line_blame = true })

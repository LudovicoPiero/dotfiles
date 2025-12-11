return {
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
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>rf", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gl", function() Snacks.lazygit() end, desc = "LazyGit" },
    { "<leader>sf", function() Snacks.picker.files({ matcher = { frecency = true, history_bonus = true, ignorecase = false } }) end, desc = "Search Files" },
    { "<leader>s.", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Live Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Current Word" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Grep Buffer" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Document Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Workspace Diagnostics" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sb", function() Snacks.picker.pickers() end, desc = "Snacks Pickers" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Search Help" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search Keymaps" },
    -- Todo Comments Integration
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Search Todos" },
    { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Search specific Todos" },
  },
}

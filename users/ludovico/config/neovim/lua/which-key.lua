local o = vim.opt
local g = vim.g
local wk = require("which-key")

o.timeout = true
o.timeoutlen = 300
g.mapleader = " "

wk.setup({})
local mappings = {
  ["/"] = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
  ["w"] = { "<cmd>update!<CR>", "Save" },
  ["q"] = { "<cmd>q!<CR>", "Quit" },

  b = { "<cmd>Telescope buffers<cr>", "Buffers" },
  f = {
    name = "File",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    n = { "<cmd>enew<cr>", "New File" },
  },

  g = {
    name = "Git",
    s = { "<cmd>Neogit<CR>", "Status" },
  },

  k = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
  p = { "\"+p", "Paste from clipboard" },
  P = { "\"+P", "Paste from clipboard before cursor" },
  y = { "\"+y", "Yank to clipboard" },
}

local opts = {
  mode = "n",     -- Normal mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = false, -- use `nowait` when creating keymaps
}

local conf = {
  window = {
    border = "single",   -- none, single, double, shadow
    position = "bottom", -- bottom, top
  },
}

wk.setup(conf)
wk.register(mappings, opts)

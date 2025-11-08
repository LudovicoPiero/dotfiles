--- @diagnostic disable: param-type-not-match, undefined-global, type-not-found, missing-fields
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- If you have a Nerd Font installed and selected in your terminal
vim.g.have_nerd_font = true

-- === UI & Display ===
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.colorcolumn = "80,100"
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.scrolloff = 10

-- === Cursor & Input ===
vim.o.mouse = "a"
vim.o.guicursor = "n-v-i-c:block-Cursor"
vim.o.timeoutlen = 300

-- === Indentation & Tabs ===
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.tabstop = 4

-- === Search & Completion ===
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false
vim.o.inccommand = "split"
vim.o.completeopt = "menuone,noselect"

-- === Splits ===
vim.o.splitbelow = true
vim.o.splitright = true

-- === File & Undo ===
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.exrc = true

-- === Misc ===
vim.o.breakindent = true
vim.o.confirm = true

-- === Clipboard ===
vim.o.clipboard = "unnamedplus"

-- Use ; instead of :
vim.keymap.set("", ";", ":", { desc = "Use ; instead of :" })

-- Smarter j/k (move by display line when no count)
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Kickstart-style mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Terminal mode escape
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--- Auto-commands ---
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-close help, quickfix, etc. with 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "qf",
    "lspinfo",
    "man",
    "checkhealth",
    "notify",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

--- Plugin management with lazy.nvim ---
-- mnw is a global set by mnw
-- so if it's set this config is being ran from nix
if mnw ~= nil then
  -- Thank you https://nixalted.com/lazynvim-nixos.html
  require("lazy").setup({
    dev = {
      path = mnw.configDir .. "/pack/mnw/opt",
      -- match all plugins
      patterns = { "" },
      -- fallback to downloading plugins from git
      -- disable this to force only using nix plugins
      fallback = true,
    },

    -- keep rtp/packpath the same
    performance = {
      reset_packpath = false,
      rtp = {
        reset = false,
      },
    },

    install = {
      -- install missing plugins
      missing = true,
    },

    spec = {
      { import = "plugins" },
    },
  })
else
  -- otherwise we have to bootstrap lazy ourself
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    spec = {
      { import = "plugins" },
    },
  })
end

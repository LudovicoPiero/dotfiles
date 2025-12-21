vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- Helper function for Super Tab
function has_words_before()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match("%s") == nil
end

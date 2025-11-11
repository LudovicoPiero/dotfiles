-- === UI & Display ===
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.colorcolumn = "80,100"
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.showmode = false
vim.o.scrolloff = 10
vim.o.winborder = "rounded"

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

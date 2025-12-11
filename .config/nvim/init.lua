-- Set mapleader before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load Core Settings
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup Lazy
require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Import everything from lua/plugins/*.lua
  },
  checker = { enabled = false }, -- Don't check for updates automatically
  change_detection = { notify = false },
})

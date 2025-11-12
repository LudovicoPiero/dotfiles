---@diagnostic disable: undefined-global
-- Only run if mnw is available (i.e., under Nix)
if mnw == nil then
  return
end

-- Add your plugin directory to runtimepath
local plugin_root = mnw.configDir .. "/pack/mnw/start/lain/nvim"
vim.opt.rtp:prepend(plugin_root)

-- Ensure packpath includes the rest of the plugins
vim.opt.packpath:prepend(mnw.configDir .. "/pack")

-- Automatically load all optional plugins under pack/mnw/opt
local opt_dir = mnw.configDir .. "/pack/mnw/opt"
for name, type in vim.fs.dir(opt_dir) do
  if type == "directory" then
    pcall(vim.cmd.packadd, name)
  end
end

-- Load your configuration modules
require("config.globals")
require("config.colorscheme")
require("config.options")
require("config.keymaps")
require("config.autocmd")
require("config.lsp")

require("plugins")

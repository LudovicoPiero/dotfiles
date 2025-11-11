---@diagnostic disable: undefined-global
-- lua/plugins/init.lua
---@diagnostic disable: undefined-global

local plugin_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local handle = vim.loop.fs_scandir(plugin_dir)

if handle then
  while true do
    local name = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end
    if name:sub(-4) == ".lua" and name ~= "init.lua" then
      local mod = "plugins." .. name:sub(1, -5)
      local ok, err = pcall(require, mod)
      if not ok then
        vim.notify("Failed loading plugin config: " .. mod .. "\n" .. err, vim.log.levels.ERROR)
      end
    end
  end
end

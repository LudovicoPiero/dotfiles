return {
  -- Command and arguments to start the server.
  cmd = { "emmylua_ls" },

  -- Filetypes to automatically attach to.
  filetypes = { "lua" },

  -- Sets the "root directory" to the parent directory of the file in the
  -- the connection to the same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = {
    { ".luarc.json", ".emmyrc.json" },
    ".luacheckrc",
    ".git",
  },

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
    },
  },
}

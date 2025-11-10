---@diagnostic disable: undefined-global
return {
  "fzf-lua",
  event = { "DeferredUIEnter" },
  after = function()
    require("fzf-lua").setup({
      fzf_opts = {
        ["--layout"] = "default",
      },
      winopts = {
        preview = {
          vertical = "up:50%",
          horizontal = "right:50%",
          delay = 10,
        },
      },
    })

    -- Use fzf-lua for vim.ui.select
    require("fzf-lua").register_ui_select()
  end,

  keys = {
    {
      "<leader>sq",
      function()
        FzfLua.quickfix()
      end,
      desc = "[S]earch [Q]uickfix List",
    },
    {
      "<leader>sh",
      function()
        FzfLua.helptags()
      end,
      desc = "[S]earch [H]elp",
    },
    {
      "<leader>sk",
      function()
        FzfLua.keymaps()
      end,
      desc = "[S]earch [K]eymaps",
    },
    {
      "<leader>sf",
      function()
        FzfLua.files()
      end,
      desc = "[S]earch [F]iles",
    },
    {
      "<leader>sb",
      function()
        FzfLua.builtin()
      end,
      desc = "[S]earch [B]uiltin FzfLua",
    },
    {
      "<leader>sw",
      function()
        FzfLua.grep_cword()
      end,
      desc = "[S]earch current [W]ord",
    },
    {
      "<leader>sg",
      function()
        FzfLua.live_grep()
      end,
      desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sd",
      function()
        FzfLua.diagnostics_document()
      end,
      desc = "[S]earch [d]iagnostic documents",
    },
    {
      "<leader>sD",
      function()
        FzfLua.diagnostics_workspace()
      end,
      desc = "[S]earch [D]iagnostic workspace",
    },
    {
      "<leader>s.",
      function()
        FzfLua.oldfiles()
      end,
      desc = "[S]earch Recent Files ('.' for repeat)",
    },
    {
      "<leader><leader>",
      function()
        FzfLua.buffers()
      end,
      desc = "[ ] Find existing buffers",
    },
    {
      "<leader>/",
      function()
        FzfLua.lgrep_curbuf()
      end,
      desc = "[S]earch [/] in Open Files",
    },
  },
}

return {
  -- Discord RPC
  {
    "IogaMaster/neocord",
    event = "VeryLazy",
    config = function()
      require("neocord").setup({
        logo = "auto",
        main_image = "language",
        client_id = "1157438221865717891",
        show_time = true,
        global_timer = true,
        editing_text = "Editing %s",
        file_explorer_text = "Browsing %s",
        git_commit_text = "Committing changes",
        plugin_manager_text = "Managing plugins",
        reading_text = "Reading %s",
        workspace_text = "Working on %s",
        line_number_text = "Line %s out of %s",
        terminal_text = "Using Terminal",
      })
    end,
  },

  -- None-LS (Linting/Code Actions)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      null_ls.setup({
        sources = {
          -- NOTE: Install 'statix' and 'deadnix' via emerge or mason
          diagnostics.deadnix,
          diagnostics.statix,
          code_actions.statix,

          -- NOTE: Install 'golangci-lint' manually
          diagnostics.golangci_lint,
        },
      })
    end,
  },
}

return {
  "nvim-orgmode/orgmode",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", lazy = true },
  },
  event = "VeryLazy",
  config = function()
    -- Load treesitter grammar for org
    require("orgmode").setup_ts_grammar()
    -- Setup treesitter
    require("orgmode").setup({
      org_agenda_files = "~/Documents/**/*",
      org_default_notes_file = "~/Documents/refile.org",
    })
  end,
}

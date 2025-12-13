return {
  "echasnovski/mini.nvim",
  event = "VeryLazy",
  config = function()
    local has_icons = vim.g.have_nerd_font

    -- AI and Splitjoin
    require("mini.ai").setup({ n_lines = 500 })
    require("mini.splitjoin").setup()

    -- Surround
    require("mini.surround").setup({
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    })

    -- Statusline
    local statusline = require("mini.statusline")
    statusline.setup({ use_icons = has_icons })
    statusline.section_location = function()
      return "%2l:%-2v"
    end

    -- Misc
    local misc = require("mini.misc")
    misc.setup()
    misc.setup_restore_cursor()
    misc.setup_termbg_sync()
  end,
}

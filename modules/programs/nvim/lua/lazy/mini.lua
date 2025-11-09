return {
  {
    "mini.nvim",
    after = function()
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.splitjoin").setup()

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

      local statusline = require("mini.statusline")
      statusline.setup({ use_icons = vim.g.have_nerd_font })
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      vim.keymap.set("n", "<leader>bd", function()
        local bd = require("mini.bufremove").delete
        if vim.bo.modified then
          local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
          if choice == 1 then
            vim.cmd.write()
            bd(0)
          elseif choice == 2 then
            bd(0, true)
          end
        else
          bd(0)
        end
      end, { desc = "Delete Buffer" })

      vim.keymap.set("n", "<leader>bD", function()
        require("mini.bufremove").delete(0, true)
      end, { desc = "Delete Buffer (Force)" })
    end,
  },
}

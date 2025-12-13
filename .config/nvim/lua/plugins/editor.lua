return {
  -- Oil (File Explorer)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "permissions", "mtime", "size", "icon" },
      })
      vim.keymap.set("n", "<leader>tf", "<CMD>Oil<CR>", { desc = "[T]oggle [F]ile Explorer", silent = true })
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        preview_config = { border = "rounded" },
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, "Next Git Hunk")

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, "Prev Git Hunk")

          map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Hunk")
          map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
          map("n", "<leader>gS", gitsigns.stage_buffer, "Stage Buffer")
          map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
          map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
          map("n", "<leader>gb", gitsigns.blame_line, "Blame Line")
          map("n", "<leader>gd", gitsigns.diffthis, "Diff (Index)")
          map("n", "<leader>gD", function()
            gitsigns.diffthis("@")
          end, "Diff (Commit)")
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle Git Blame")
          map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle Deleted")
        end,
      })
    end,
  },

  -- Flash (Motion)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = { mode = "fuzzy" },
      jump = { autojump = true },
      modes = { char = { jump_labels = true } },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<C-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- Guess Indent
  {
    "nmac427/guess-indent.nvim",
    event = "BufReadPre",
    config = function()
      require("guess-indent").setup({})
    end,
  },

  -- Todo Comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    config = function()
      require("todo-comments").setup({
        signs = false,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          keyword = "wide",
          after = "fg",
        },
      })
      -- Note: Keys are mapped in Snacks.nvim config below to match your previous setup
    end,
  },
}

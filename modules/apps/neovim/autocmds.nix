{ config, lib, ... }:
{
  config = lib.mkIf config.mine.nvim.enable {
    programs.nvf.settings.vim = {
      augroups = [
        { name = "lain_highlight_yank"; }
        { name = "lain_close_with_q"; }
        { name = "lain_auto_create_dir"; }
        { name = "lain_help_split"; }
        { name = "lain_filetype_settings"; }
        { name = "lain_clear_lsp_refs"; }
        { name = "lain_trim_whitespace"; }
        { name = "lain_resize_splits"; }
        { name = "AutoRefreshFile"; }
      ];

      autocmds = [
        # Highlight yanked text
        {
          event = [ "TextYankPost" ];
          group = "lain_highlight_yank";
          desc = "Highlight yanked text";
          callback = lib.generators.mkLuaInline ''
            function()
              (vim.hl or vim.highlight).on_yank()
            end
          '';
        }

        # Close certain filetypes with 'q'
        {
          event = [ "FileType" ];
          group = "lain_close_with_q";
          pattern = [
            "help"
            "qf"
            "man"
            "notify"
            "checkhealth"
            "lspinfo"
            "startuptime"
            "tsplayground"
            "PlenaryTestPopup"
            "gitsigns.blame"
          ];
          callback = lib.generators.mkLuaInline ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
            end
          '';
        }

        # Auto-create intermediate directories on save
        {
          event = [ "BufWritePre" ];
          group = "lain_auto_create_dir";
          callback = lib.generators.mkLuaInline ''
            function(event)
              if event.match:match("^%w%w+:[\\/][\\/]") then
                return
              end
              local file = vim.uv.fs_realpath(event.match) or event.match
              vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
            end
          '';
        }

        # Open help in a vertical split
        {
          event = [ "FileType" ];
          group = "lain_help_split";
          pattern = [ "help" ];
          command = "wincmd L";
        }

        # Set .env files to sh filetype
        {
          event = [
            "BufRead"
            "BufNewFile"
          ];
          group = "lain_filetype_settings";
          pattern = [
            ".env"
            ".env.*"
          ];
          callback = lib.generators.mkLuaInline ''
            function()
              vim.bo.filetype = "sh"
            end
          '';
        }

        # Clear LSP references on cursor move in insert mode
        {
          event = [ "CursorMovedI" ];
          group = "lain_clear_lsp_refs";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.lsp.buf.clear_references()
            end
          '';
        }

        # Trim trailing whitespace on save (skip markdown and binary)
        {
          event = [ "BufWritePre" ];
          group = "lain_trim_whitespace";
          pattern = [ "*" ];
          callback = lib.generators.mkLuaInline ''
            function()
              if vim.bo.filetype == "markdown" or vim.bo.binary then
                return
              end
              local save = vim.fn.winsaveview()
              vim.cmd([[keeppatterns %s/\s\+$//e]])
              vim.fn.winrestview(save)
            end
          '';
        }

        # Resize splits when the terminal window is resized
        {
          event = [ "VimResized" ];
          group = "lain_resize_splits";
          callback = lib.generators.mkLuaInline ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabdo wincmd =")
              vim.cmd("tabnext " .. current_tab)
            end
          '';
        }

        # Auto-refresh: check if file changed on disk when switching focus/buffers
        {
          event = [
            "FocusGained"
            "BufEnter"
            "CursorHold"
            "CursorHoldI"
          ];
          group = "AutoRefreshFile";
          callback = lib.generators.mkLuaInline ''
            function()
              if vim.o.buftype == "" and not vim.api.nvim_buf_get_name(0):match("^%w+://") then
                vim.cmd("checktime")
              end
            end
          '';
        }

        # Notify after buffer is reloaded from disk change
        {
          event = [ "FileChangedShellPost" ];
          group = "AutoRefreshFile";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.notify("File changed on disk. Buffer reloaded automatically.", vim.log.levels.WARN)
            end
          '';
        }
      ];
    };
  };
}

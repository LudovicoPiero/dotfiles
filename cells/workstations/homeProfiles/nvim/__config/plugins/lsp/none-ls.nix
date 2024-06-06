{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.none-ls = {
      enable = true;
      sources = {
        formatting = {
          # C / C++
          clang_format.enable = true;

          # C-sharp
          csharpier.enable = true;

          # Nix
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };

          # Lua
          stylua.enable = true;

          # Bash / SH
          shfmt.enable = true;

          # Python
          black.enable = true;
          isort.enable = true;

          # JS Family
          prettier = {
            disableTsServerFormatter = true;
            enable = true;
          };

          # Go
          gofmt.enable = true;
        };
      };
      # onAttach = ''
      #   function(client, bufnr)
      #     if client.supports_method("textDocument/formatting") then
      #       vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("LspFormatting", {}), buffer = bufnr })
      #       vim.api.nvim_create_autocmd("BufWritePre", {
      #         group = vim.api.nvim_create_augroup("LspFormatting", {}),
      #         buffer = bufnr,
      #         callback = function()
      #             vim.lsp.buf.format({ async = false })
      #         end,
      #       })
      #     end
      #   end
      # '';
    };

    keymaps = [
      {
        mode = "";
        key = "<leader>ff";
        action = "<cmd>lua vim.lsp.buf.format()<cr>";
        options = {
          desc = "Format Buffer";
          silent = true;
        };
      }
    ];
  };
}

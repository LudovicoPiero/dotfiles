{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      lsp-lines.enable = true;

      luasnip = {
        enable = true;
        fromVscode = [ { paths = "${pkgs.vimPlugins.friendly-snippets}"; } ];
        extraConfig = {
          history = true;
          delete_check_events = "TextChanged";
        };
      };

      lspkind = {
        enable = true;

        cmp = {
          enable = true;

          menu = {
            buffer = "[Buffer]";
            calc = "[Calc]";
            cmdline = "[Cmdline]";
            codeium = "[Codeium]";
            emoji = "[Emoji]";
            git = "[Git]";
            luasnip = "[Snippet]";
            neorg = "[Neorg]";
            nvim_lsp = "[LSP]";
            nvim_lua = "[API]";
            path = "[Path]";
            spell = "[Spell]";
            treesitter = "[TreeSitter]";
          };
        };
      };

      lsp = {
        enable = true;

        preConfig = ''
          -- add additional capabilities supported by nvim-cmp
          -- nvim has not added foldingRange to default capabilities, users must add it manually
          local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities(),
            -- File watching is disabled by default for neovim.
            -- See: https://github.com/neovim/neovim/pull/22405
            { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
          )
          capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }
        '';

        postConfig = ''
          -- Change diagnostic symbols in the sign column (gutter)
          local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
          for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
          end
          vim.diagnostic.config({
            virtual_text = false,
            signs = true,
            underline = true,
            update_in_insert = true,
            severity_sort = false,
          })
        '';

        servers = {
          ccls = {
            enable = true;
            filetypes = [
              "c"
              "cpp"
              "objc"
              "objcpp"
            ];

            initOptions.compilationDatabaseDirectory = "out/release";
          };

          csharp-ls = {
            enable = true;
            filetypes = [ "cs" ];
          };

          dockerls = {
            enable = true;
            filetypes = [ "dockerfile" ];
          };

          bashls = {
            enable = true;
            filetypes = [
              "sh"
              "bash"
            ];
          };

          pyright = {
            enable = true;
            filetypes = [ "py" ];
          };

          html = {
            enable = true;
            filetypes = [ "html" ];
          };

          cssls = {
            enable = true;
            filetypes = [ "css" ];
          };

          tsserver = {
            enable = true;
            filetypes = [
              "ts"
              "tsx"
              "javascript"
              "javascriptreact"
              "typescript"
              "typescriptreact"
            ];
          };

          lua-ls = {
            enable = true;
            filetypes = [ "lua" ];
            extraOptions = {
              settings = {
                Lua = {
                  completion = {
                    callSnippet = "Replace";
                  };
                  telemetry = {
                    enabled = false;
                  };
                  hint = {
                    enable = true;
                  };
                };
              };
            };
          };

          nixd = {
            enable = true;
            filetypes = [ "nix" ];
            settings = {
              diagnostic.suppress = [
                "sema-escaping-with"
                "var-bind-to=this"
              ];
              formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
            };
          };

          gopls = {
            enable = true;
            filetypes = [ "go" ];
            extraOptions = {
              settings = {
                experimentalPostfixCompletions = true;
                analyses = {
                  unusedparams = true;
                  shadow = true;
                };
                staticcheck = true;
              };
              init_options = {
                usePlaceholders = true;
              };
            };
          };

          rust-analyzer = {
            enable = true;
            filetypes = [ "rs" ];
            installCargo = true;
            installRustc = true;

            settings = {
              diagnostics = {
                enable = true;
                # experimental.enable = true;
                styleLints.enable = true;
              };

              files = {
                excludeDirs = [
                  ".direnv"
                  "rust/.direnv"
                ];
              };

              inlayHints = {
                bindingModeHints.enable = true;
                closureStyle = "rust_analyzer";
                closureReturnTypeHints.enable = "always";
                discriminantHints.enable = "always";
                expressionAdjustmentHints.enable = "always";
                implicitDrops.enable = true;
                lifetimeElisionHints.enable = "always";
                rangeExclusiveHints.enable = true;
              };

              procMacro = {
                enable = true;
              };
            };
          };
        };
      };

      lspsaga = {
        enable = true;
        lightbulb.sign = false;
        symbolInWinbar.enable = false;
        ui.border = "rounded";
      };
    };

    keymaps =
      let
        options = desc: {
          silent = true;
          noremap = true;
          desc = desc;
        };
      in
      [
        {
          action = "<CMD>Lspsaga code_action<CR>";
          key = "<leader>la";
          mode = "n";
          options = options "Code action";
        }
        {
          action = "<CMD>Lspsaga goto_definition<CR>";
          key = "<leader>ld";
          mode = "n";
          options = options "Go to definition";
        }
        {
          action = "<CMD>Lspsaga goto_type_definition<CR>";
          key = "<leader>lt";
          mode = "n";
          options = options "Go to type definition";
        }
        {
          action = "<CMD>Lspsaga diagnostic_jump_next<CR>";
          key = "<leader>ll";
          mode = "n";
          options = options "Next diagnostic";
        }
        {
          action = "<CMD>Lspsaga diagnostic_jump_prev<CR>";
          key = "<leader>lh";
          mode = "n";
          options = options "Previous diagnostic";
        }
        {
          action = "<CMD>Lspsaga finder<CR>";
          key = "<leader>lr";
          mode = "n";
          options = options "Show references and implementations";
        }
        {
          action = "<CMD>Lspsaga hover_doc<CR>";
          key = "<leader>lk";
          mode = "n";
          options = options "Hover documentation";
        }
        {
          action = "<CMD>Lspsaga outline<CR>";
          key = "<leader>lo";
          mode = "n";
          options = options "Outline";
        }
        {
          action = "<CMD>Lspsaga rename<CR>";
          key = "<leader>lc";
          mode = "n";
          options = options "Rename";
        }
      ];
  };
}

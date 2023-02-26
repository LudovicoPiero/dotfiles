{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # REFERENCES
  # https://gitlab.com/rycee/nur-expressions
  # https://github.com/Denommus/nix-configurations
  home-manager.users.${config.vars.username} = {
    imports = [config.nur.repos.rycee.hmModules.emacs-init];
    programs.emacs = {
      enable = true;

      init = {
        enable = true;
        recommendedGcSettings = true;
        prelude = builtins.readFile ./prelude.el;

        #TODO
        #python
        #rust
        #go
        #c family
        usePackage = {
          company = {
            enable = true;
            demand = true;
            command = [
              "company-mode"
              "global-company-mode"
            ];
            config = "(global-company-mode 1)";
          };

          hl-todo = {
            enable = true;
            demand = true;
          };

          helm = {
            enable = true;
            demand = true;
            command = [
              "helm-mode"
            ];
            bind = {
              "C-c h" = "helm-command-prefix";
              "M-x" = "helm-M-x";
              "C-c y" = "helm-show-kill-ring";
              "C-x C-f" = "helm-find-files";
            };
            bindLocal = {
              helm-map = {
                "<tab>" = "helm-execute-persistent-action";
                "C-i" = "helm-execute-persistent-action";
                "C-z" = "helm-select-action";
              };
            };
            config = builtins.readFile ./configs/helm.el;
          };

          projectile = {
            enable = true;
            diminish = ["projectile-mode"];
            command = ["projectile-mode"];
            init = "(require 'tramp)";
            demand = true;
            bindKeyMap = {
              "C-z" = "projectile-command-map";
            };
            config = builtins.readFile ./configs/projectile.el;
          };

          helm-projectile = {
            enable = true;
            demand = true;
            command = [
              "helm-projectile-on"
            ];
            after = ["projectile"];
            config = "(helm-projectile-on)";
          };

          helm-flyspell = {
            enable = true;
            after = ["helm"];
          };

          flyspell = {
            enable = true;
            after = ["helm-flyspell"];
            bindLocal = {
              flyspell-mode-map = {
                "C-;" = "helm-flyspell-correct";
              };
            };
          };

          dracula-theme = {
            enable = true;
            init = "(load-theme 'dracula t)";
          };

          magit = {
            enable = true;
            command = ["magit-custom"];
            config = builtins.readFile ./configs/magit.el;
          };

          magit-svn = {
            enable = true;
            command = ["magit-svn-mode"];
            after = ["magit"];
          };

          switch-window = {
            enable = true;
            bind = {
              "C-x o" = "switch-window";
              "C-x 1" = "switch-window-then-maximize";
              "C-x 2" = "switch-window-then-split-below";
              "C-x 3" = "switch-window-then-split-right";
              "C-x 0" = "switch-window-then-delete";
              "C-x 4 d" = "switch-window-then-dired";
              "C-x 4 f" = "switch-window-then-find-file";
              "C-x 4 m" = "switch-window-then-compose-mail";
              "C-x 4 r" = "switch-window-then-find-file-read-only";
              "C-x 4 C-f" = "switch-window-then-find-file";
              "C-x 4 C-o" = "switch-window-then-display-buffer";
              "C-x 4 0" = "switch-window-then-kill-buffer";
            };
          };

          lsp-mode = {
            enable = true;
            command = [
              "lsp"
            ];
            bindLocal = {
              lsp-mode-map = {
                "C-c C-t" = "lsp-describe-thing-at-point";
                "C-c C-r" = "lsp-rename";
                "C-c C-i" = "lsp-describe-thing-at-point";
                "C-c t" = "lsp-describe-thing-at-point";
                "C-c r" = "lsp-rename";
                "C-c i" = "lsp-describe-thing-at-point";
                "M-." = "xref-find-definitions";
              };
            };
            init = builtins.readFile ./configs/lsp.el;
          };

          lsp-nix = {
            after = ["lsp-mode"];
            demand = true;
            config = ''
              (lsp-nix-nil-formatter ["alejandra"])
            '';
          };

          nix-mode = {
            enable = true;
            demand = true;
            hook = ["(nix-mode.lsp-deferred)"];
          };

          nixos-options = {
            enable = true;
          };
        };
      };
    };
  };
}

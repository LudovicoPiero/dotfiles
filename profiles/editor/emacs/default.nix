{
  config,
  pkgs,
  ...
}: {
  # REFERENCES
  # https://gitlab.com/rycee/nur-expressions
  # https://github.com/Denommus/nix-configurations
  # https://git.sr.ht/~rycee/configurations/tree/master/item/user/emacs.nix
  home-manager.users.${config.vars.username} = {
    home.file = {
      ".emacs.d/snippets".source = ./snippets;
    };

    imports = [config.nur.repos.rycee.hmModules.emacs-init];
    services.emacs.enable = true;
    programs.emacs = {
      enable = true;
      #package = inputs.emacs-overlay.packages.${pkgs.system}.emacsPgtk;

      init = {
        enable = true;
        recommendedGcSettings = true;

        earlyInit = ''
          ;; Disable some GUI distractions. We set these manually to avoid starting
          ;; the corresponding minor modes.
          (menu-bar-mode 0)
          (tool-bar-mode 0)
          (scroll-bar-mode 0)

          ;; Set up fonts early.
          (add-to-list 'default-frame-alist
          '(font . "Iosevka Comfy 15"))
        '';

        prelude = builtins.readFile ./prelude.el;

        #TODO
        /*
        Maybe move files separately, for example
        all rust related into 1 file separately.
        - Rust.nix
        - Python.nix
        - etc.
        */
        usePackage = {
          projectile = {
            enable = true;
            diminish = ["projectile-mode"];
            command = ["projectile-mode"];
            init = "(require 'tramp)";
            demand = true;
            bindKeyMap = {
              "C-z" = "projectile-command-map";
            };
            config = ''
              (projectile-mode)
              (setq projectile-indexing-method 'alien)
              (setq projectile-mode-line "Projectile")
            '';
          };

          company = {
            enable = true;
            demand = true;
            command = [
              "company-mode"
              "global-company-mode"
            ];
            bindLocal = {
              company-active-map = {
                "C-n" = "company-select-next";
                "C-p" = "company-select-previous";
                "M-<" = "company-select-first";
                "M->" = "company-select-last";
              };
            };
            config = ''
              (global-company-mode 1)
            '';
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

          flycheck = {
            enable = true;
            command = ["global-flycheck-mode"];
            defer = 1;
            bind = {
              "M-n" = "flycheck-next-error";
              "M-p" = "flycheck-previous-error";
            };
            config = ''
              ;; Only check buffer when mode is enabled or buffer is saved.
              (setq flycheck-check-syntax-automatically '(mode-enabled save)
              flycheck-markdown-mdl-executable "${pkgs.mdl}/bin/mdl")

              ;; Enable flycheck in all eligible buffers.
              (global-flycheck-mode)
            '';
          };

          flycheck-projectile = {
            enable = true;
            after = ["flycheck" "projectile"];
          };

          catppuccin-theme = {
            enable = true;
            init = "(load-theme 'catppuccin t)";
          };

          # Configure magit, a nice mode for the git SCM.
          magit = {
            enable = true;
            command = ["magit-project-status"];
            bind = {"C-c g" = "magit-status";};
            config = ''
              (setq forge-add-pullreq-refspec 'ask)
              (add-to-list 'git-commit-style-convention-checks
              'overlong-summary-line)
            '';
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
            command = ["lsp" "lsp-deferred"];
            after = ["flycheck"];
            bindLocal = {
              lsp-mode-map = {
                "C-c f r" = "lsp-find-references";
                "C-c r a" = "lsp-execute-code-action";
                "C-c r f" = "lsp-format-buffer";
                "C-c r g" = "lsp-format-region";
                "C-c r l" = "lsp-avy-lens";
                "C-c r r" = "lsp-rename";
              };
            };
            hook = [
              "(go-mode . lsp)"
              "(nix-mode . lsp-deferred)"
              "(rust-mode . lsp)"
              "(lsp-mode . lsp-enable-which-key-integration)"
            ];
            init = ''
              (setq lsp-keymap-prefix "C-c l")
            '';
            config = ''
              (setq lsp-diagnostics-provider :flycheck
              lsp-eldoc-render-all nil
              lsp-headerline-breadcrumb-enable nil
              lsp-modeline-code-actions-enable nil
              lsp-modeline-diagnostics-enable nil
              lsp-modeline-workspace-status-enable nil
              lsp-lens-enable t)
              (setq lsp-rust-server 'rust-analyzer
              lsp-nix-server 'nil
              lsp-nix-nil-formatter 'alejandra)
              (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
            '';
          };

          lsp-ui = {
            enable = true;
            command = ["lsp-ui-mode"];
            bindLocal = {
              lsp-mode-map = {
                "C-c r d" = "lsp-ui-doc-toggle";
                "C-c r i" = "lsp-ui-doc-focus-frame";
                "C-c f s" = "lsp-ui-find-workspace-symbol";
              };
            };
            config = ''
              (setq lsp-ui-sideline-enable t
              lsp-ui-sideline-show-symbol nil
              lsp-ui-sideline-show-hover t
              lsp-ui-doc-enable nil
              lsp-ui-sideline-show-code-actions nil
              lsp-ui-sideline-update-mode 'point)
              (setq lsp-ui-doc-enable nil
              lsp-ui-doc-position 'at-point
              lsp-ui-doc-max-width 125
              lsp-ui-doc-max-height 18)
            '';
          };

          lsp-ui-flycheck = {
            enable = true;
            after = ["flycheck" "lsp-ui"];
          };

          lsp-completion = {
            enable = true;
            after = ["lsp-mode"];
            config = ''
              (setq lsp-completion-enable-additional-text-edit nil)
            '';
          };

          lsp-diagnostics = {
            enable = true;
            after = ["lsp-mode"];
          };

          lsp-lens = {
            enable = true;
            command = ["lsp-lens--enable"];
            after = ["lsp-mode"];
          };

          lsp-nix = {
            after = ["lsp-mode"];
            demand = true;
          };

          nix-mode = {
            enable = true;
            demand = true;
            mode = ["\\.nix\\"];
            hook = ["(nix-mode . lsp-deferred)"];
            bindLocal = {
              nix-mode-map = {
                "C-c f f" = "nix-mode-format";
              };
            };
          };

          ripgrep = {
            enable = true;
            command = ["ripgrep-regexp"];
          };

          vertico = {
            enable = true;
            command = ["vertico-mode" "vertico-next"];
            init = "(vertico-mode)";
          };

          org = {
            enable = true;
            bind = {
              "C-c o c" = "org-capture";
              "C-c o a" = "org-agenda";
              "C-c o l" = "org-store-link";
              "C-c o b" = "org-switchb";
            };
            hook = [
              ''
                (org-mode
                . (lambda ()
                (add-hook 'completion-at-point-functions
                'pcomplete-completions-at-point nil t)))
              ''
            ];
            config = ''
              ;; Some general stuff.
              (setq org-reverse-note-order t
              org-use-fast-todo-selection t
              org-adapt-indentation nil
              org-hide-leading-stars t
              org-hide-emphasis-markers t
              org-ctrl-k-protect-subtree t
              org-pretty-entities t
              org-ellipsis "…")

              ;; Add some todo keywords.
              (setq org-todo-keywords
              '((sequence "TODO(t)"
              "STARTED(s!)"
              "WAITING(w@/!)"
              "DELEGATED(@!)"
              "|"
              "DONE(d!)"
              "CANCELED(c@!)")))

              ;; Unfortunately org-mode tends to take over keybindings that
              ;; start with C-c.
              (unbind-key "C-c SPC" org-mode-map)
              (unbind-key "C-c w" org-mode-map)
              (unbind-key "C-'" org-mode-map)
            '';
          };

          org-agenda = {
            enable = true;
            after = ["org"];
            defer = true;
            config = ''
              ;; Set up agenda view.
              (setq org-agenda-span 5
              org-deadline-warning-days 14
              org-agenda-show-all-dates t
              org-agenda-skip-deadline-if-done t
              org-agenda-skip-scheduled-if-done t
              org-agenda-start-on-weekday nil)
            '';
          };

          org-modern = {
            enable = true;
            hook = [
              "(org-mode . org-modern-mode)"
              "(org-agenda-finalize . org-modern-agenda)"
            ];
          };

          org-roam = {
            enable = true;
            command = ["org-roam-db-autosync-mode"];
            defines = ["org-roam-v2-ack"];
            bind = {"C-' f" = "org-roam-node-find";};
            bindLocal = {
              org-mode-map = {
                "C-' b" = "org-roam-buffer-toggle";
                "C-' i" = "org-roam-node-insert";
              };
            };
            init = ''
              (setq org-roam-v2-ack t)
            '';
            config = ''
              (setq org-roam-directory "~/roam")
              (org-roam-db-autosync-mode)
            '';
          };

          org-table = {
            enable = true;
            after = ["org"];
            command = ["orgtbl-to-generic"];
            functions = ["org-combine-plists"];
            hook = [
              # For orgtbl mode, add a radio table translator function for
              # taking a table to a psql internal variable.
              ''
                (orgtbl-mode
                . (lambda ()
                (defun rah-orgtbl-to-psqlvar (table params)
                "Converts an org table to an SQL list inside a psql internal variable"
                (let* ((params2
                (list
                :tstart (concat "\\set " (plist-get params :var-name) " '(")
                :tend ")'"
                :lstart "("
                :lend "),"
                :sep ","
                :hline ""))
                (res (orgtbl-to-generic table (org-combine-plists params2 params))))
                (replace-regexp-in-string ",)'$"
                ")'"
                (replace-regexp-in-string "\n" "" res))))))
              ''
            ];
            config = ''
              (unbind-key "C-c SPC" orgtbl-mode-map)
              (unbind-key "C-c w" orgtbl-mode-map)
            '';
          };

          org-capture = {
            enable = true;
            after = ["org"];
          };

          yasnippet = {
            enable = true;
            command = ["yas-global-mode" "yas-minor-mode" "yas-expand-snippet"];
            hook = [
              # Yasnippet interferes with tab completion in ansi-term.
              "(term-mode . (lambda () (yas-minor-mode -1)))"
            ];
            config = "(yas-global-mode 1)";
          };

          yasnippet-snippets = {
            enable = true;
            after = ["yasnippet"];
          };

          consult = {
            enable = true;
            bind = {
              "C-x p" = "consult-line";
              "C-x b" = "consult-buffer";
              "M-g M-g" = "consult-goto-line";
              "M-g g" = "consult-goto-line";
              "M-s f" = "consult-find";
              "M-s r" = "consult-ripgrep";
              "M-y" = "consult-yank-pop";
            };
            config = ''
              (defvar rah/consult-line-map
              (let ((map (make-sparse-keymap)))
              (define-key map "\C-s" #'vertico-next)
              map))

              (consult-customize
              consult-line
              :history t ;; disable history
              :keymap rah/consult-line-map
              consult-buffer consult-find consult-ripgrep
              :preview-key (kbd "M-.")
              consult-theme
              :preview-key '(:debounce 1 any)
              )
            '';
          };

          dashboard = {
            enable = true;
            demand = true;
            config = ''
              (dashboard-setup-startup-hook)
              (setq dashboard-banner-logo-title "Ludovico Sforza")
              (setq dashboard-center-content t)
            '';
          };

          direnv = {
            enable = true;
            config = "(direnv-mode)";
          };

          highlight-indent-guides = {
            enable = true;
            config = "(highlight-indent-guides-mode)";
          };

          tree-sitter = {
            enable = true;
            demand = true;
            config = ''
              (global-tree-sitter-mode)
              (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
            '';
          };

          tree-sitter-langs = {
            enable = true;
            demand = true;
          };

          which-key = {
            enable = true;
            config = "(which-key-mode)";
          };

          nixos-options = {
            enable = true;
          };

          nix-sandbox = {
            enable = true;
            command = ["nix-current-sandbox" "nix-shell-command"];
          };

          multiple-cursors = {
            enable = true;
            bind = {
              "C-S-c C-S-c" = "mc/edit-lines";
              "C-c m" = "mc/mark-all-like-this";
              "C->" = "mc/mark-next-like-this";
              "C-<" = "mc/mark-previous-like-this";
            };
          };

          lsp-rust = {
            enable = true;
            defer = true;
            hook = ["(rust-mode . lsp-deferred)"];
            config = ''
              (setq rust-format-on-save t)
            '';
          };

          rust-mode.enable = true;

          rustic = {
            enable = true;
            bindLocal = {
              rustic-mode-map = {
                "M-j" = "lsp-ui-imenu";
                "M-?" = "lsp-find-references";
                "C-c C-c l" = "flycheck-list-errors";
                "C-c C-c a" = "lsp-execute-code-action";
                "C-c C-c r" = "lsp-rename";
                "C-c C-c q" = "lsp-workspace-restart";
                "C-c C-c Q" = "lsp-workspace-shutdown";
                "C-c C-c s" = "lsp-rust-analyzer-status";
              };
            };
            config = ''
              ;; uncomment for less flashiness
              ;; (setq lsp-eldoc-hook nil)
              ;; (setq lsp-enable-symbol-highlighting nil)
              ;; (setq lsp-signature-auto-activate nil)

              ;; comment to disable rustfmt on save
              (setq rustic-format-on-save t)
              (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)

              (defun rk/rustic-mode-hook ()
              (when buffer-file-name
              (setq-local buffer-save-without-query t))
              (add-hook 'before-save-hook 'lsp-format-buffer nil t))
            '';
          };
        };
      };
    };
  };
}

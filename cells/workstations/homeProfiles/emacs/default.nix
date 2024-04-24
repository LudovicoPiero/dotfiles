{ pkgs, config, ... }:
let
  emacs-git = pkgs.emacs-git.override {
    withTreeSitter = true;
    withNativeCompilation = true;
    withPgtk = true;
  };
in
{
  imports = [ ./__modules/emacs-init.nix ];

  home.file = {
    ".emacs.d/snippets".source = ./__snippets;
  };

  services.emacs = {
    enable = true; # if False, using hyprland's exec-once
    package = config.programs.emacs.finalPackage;
    client.arguments = [ "-c" ];
  };
  programs.emacs = {
    enable = true;
    package = emacs-git;
    extraPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];

    init = {
      enable = true;
      recommendedGcSettings = true;

      earlyInit = ''
        ;; Disable some GUI distractions. We set these manually to avoid starting
        ;; the corresponding minor modes.
        (menu-bar-mode 0)
        (tool-bar-mode 0)
        (scroll-bar-mode 0)
      '';

      prelude = ''
        (custom-set-variables
          '(inhibit-startup-screen t))

        ;; Set a font
        (add-to-list 'default-frame-alist
                      '(font . "Iosevka q SemiBold 15"))

        (column-number-mode 1)
        (global-display-line-numbers-mode)
        (setq-default indent-tabs-mode nil)
        (setq-default tab-width 2)

        ;; Remembering minibuffer prompt history
        (setq history-length 25)
        (savehist-mode 1)

        ;; Prevent using UI dialogs for prompts
        (setq use-dialog-box nil)

        ;; Disable lock files (.#filenameblabla)
        (setq create-lockfiles nil)

        ;; Automatically revert buffers when files change on disk
        (global-auto-revert-mode t)

        ;; You can select text and delete it by typing.
        (delete-selection-mode 1)

        (fset 'yes-or-no-p 'y-or-n-p)

        ;; Global Keybinding
        (global-set-key (kbd "C-M-j") 'buffer-menu)

        ;; Set Backup Directory
        (setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
              backup-by-copying      t  ; Don't de-link hard links
              version-control        t  ; Use version numbers on backups
              delete-old-versions    t  ; Automatically delete excess backups:
              kept-new-versions      10 ; how many of the newest versions to keep
              kept-old-versions      5) ; and how many of the old

        ;; Stop creating backup and autosave files
        (setq make-backup-files nil
              auto-save-default nil)

        ;; Default is 4k, which is too low for LSP.
        (setq read-process-output-max (* 1024 1024))

        ;; Improved handling of clipboard
        (setq select-enable-clipboard t
              select-enable-primary t
              save-interprogram-paste-before-kill t)

        ;; Avoid noisy bell.
        (setq visible-bell t
              ring-bell-function #'ignore)

        ;; Long text goes below
        (global-visual-line-mode t)

        ;; Trailing white space are banned!
        (setq-default show-trailing-whitespace t)

        ;; Use one space to end sentences.
        (setq sentence-end-double-space nil)

        ;; I typically want to use UTF-8.
        (prefer-coding-system 'utf-8)

        ;; Nicer handling of regions.
        (transient-mark-mode 1)

        (add-hook 'org-mode-hook
          (lambda ()
            (electric-indent-local-mode -1)
            (setq org-edit-src-content-indentation 0)))

        (defun airi-lsp ()
          (interactive)
          (lsp))
      '';

      usePackageVerbose = true;
      usePackage = {
        # Evil Mode
        evil = {
          enable = true;
          init = ''
            (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
            (setq evil-want-keybinding nil)
            (setq evil-vsplit-window-right t)
            (setq evil-split-window-below t)

            ;; ----- Setting cursor colors
            (setq evil-emacs-state-cursor    '("#649bce" box))
            (setq evil-normal-state-cursor   '("#d9a871" box))
            (setq evil-operator-state-cursor '("#ebcb8b" hollow))
            (setq evil-visual-state-cursor   '("#677691" box))
            (setq evil-insert-state-cursor   '("#eb998b" box))
            (setq evil-replace-state-cursor  '("#eb998b" hbar))
            (setq evil-motion-state-cursor   '("#ad8beb" box))
            (evil-mode)
          '';
        };

        evil-collection = {
          enable = true;
          after = [ "evil" ];
          config = ''(evil-collection-init)'';
        };

        evil-surround = {
          enable = true;
          after = [ "evil" ];
          config = ''(global-evil-surround-mode 1)'';
        };

        evil-nerd-commenter.enable = true;

        flycheck = {
          enable = true;
          command = [ "global-flycheck-mode" ];
          defer = 1;
          diminish = [ "flycheck-mode" ];
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
        # Needed by Flycheck.
        pkg-info = {
          enable = true;
          command = [ "pkg-info-version-info" ];
        };

        treemacs = {
          enable = true;
          extraPackages = [ pkgs.python3 ];
          bind = {
            "C-c t f" = "treemacs-find-file";
            "C-c t t" = "treemacs";
          };
        };

        # Company
        company = {
          enable = true;
          defer = 1;
          diminish = [ "company-mode" ];
          config = ''
            (setq company-begin-commands '(self-insert-command))
            (setq company-idle-delay .5)
            (setq company-minimum-prefix-length 1)
            (setq company-show-numbers t)
            (setq company-tooltip-align-annotations 't)
            (global-company-mode t)
          '';
        };

        company-box = {
          enable = true;
          after = [ "company" ];
          diminish = [ "company-box-mode" ];
          hook = [ "(company-mode . company-box-mode)" ];
        };

        company-quickhelp = {
          enable = true;
          after = [ "company" ];
          config = ''(company-quickhelp-mode)'';
        };

        # Dired
        all-the-icons-dired = {
          enable = true;
          hook = [ "(dired-mode . (lambda () (all-the-icons-dired-mode t)))" ];
        };
        dired-open = {
          enable = true;
          config = ''
            ;; Customize file associations for opening files in Dired
            (setq dired-open-extensions '(("gif" . "imv")
                                          ("jpg" . "imv")
                                          ("png" . "imv")
                                          ("mkv" . "mpv")
                                          ("mp4" . "mpv")))
          '';
        };
        peep-dired = {
          enable = true;
          after = [ "dired" ];
          hook = [ "(evil-normalize-keymaps . peep-dired-hook)" ];
          config = ''
            ;; Customize key bindings for peep-dired
            (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
            (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ;; use dired-find-file instead if not using dired-open package
            (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
            (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
          '';
        };

        # general = {
        #   enable = true;
        #   after = [
        #     "evil"
        #     "which-key"
        #   ];
        #   config = ''
        #     (general-evil-setup)
        #
        #     ;; set up 'SPC' as the global leader key
        #     (general-create-definer airi/leader-keys
        #       :states '(normal insert visual emacs)
        #       :keymaps 'override
        #       :prefix "SPC" ;; set leader
        #       :global-prefix "M-SPC") ;; access leader in insert mode
        #
        #     (airi/leader-keys
        #         "." '(find-file :wk "Find file")
        #         "fr" '(recentf :wk "Find recent files")
        #         "ff" '(lsp-format-buffer :wk "Format Buffer") ;; TODO: move this somewhere
        #         "TAB TAB" '(evilnc-comment-or-uncomment-lines :wk "Comment lines"))
        #
        #     (airi/leader-keys
        #       "b" '(:ignore t :wk "Bookmarks/Buffers")
        #       "bb" '(switch-to-buffer :wk "Switch to buffer")
        #       "bc" '(clone-indirect-buffer :wk "Create indirect buffer copy in a split")
        #       "bC" '(clone-indirect-buffer-other-window :wk "Clone indirect buffer in new window")
        #       "bd" '(bookmark-delete :wk "Delete bookmark")
        #       "bi" '(ibuffer :wk "Ibuffer")
        #       "bk" '(kill-current-buffer :wk "Kill current buffer")
        #       "bK" '(kill-some-buffers :wk "Kill multiple buffers")
        #       "bl" '(list-bookmarks :wk "List bookmarks")
        #       "bm" '(bookmark-set :wk "Set bookmark")
        #       "bn" '(next-buffer :wk "Next buffer")
        #       "bp" '(previous-buffer :wk "Previous buffer")
        #       "br" '(revert-buffer :wk "Reload buffer")
        #       "bR" '(rename-buffer :wk "Rename buffer")
        #       "bs" '(basic-save-buffer :wk "Save buffer")
        #       "bS" '(save-some-buffers :wk "Save multiple buffers")
        #       "bw" '(bookmark-save :wk "Save current bookmarks to bookmark file"))
        #
        #     (airi/leader-keys
        #       "d" '(:ignore t :wk "Dired")
        #       "dd" '(dired :wk "Open dired")
        #       "dj" '(dired-jump :wk "Dired jump to current")
        #       "dp" '(peep-dired :wk "Peep-dired"))
        #
        #
        #     (airi/leader-keys
        #       "e" '(:ignore t :wk "Eshell/Evaluate")
        #       "eb" '(eval-buffer :wk "Evaluate elisp in buffer")
        #       "ed" '(eval-defun :wk "Evaluate defun containing or after point")
        #       "ee" '(eval-expression :wk "Evaluate and elisp expression")
        #       "el" '(eval-last-sexp :wk "Evaluate elisp expression before point")
        #       "er" '(eval-region :wk "Evaluate elisp in region")
        #       "es" '(eshell :which-key "Eshell"))
        #
        #     (airi/leader-keys
        #       "g" '(:ignore t :wk "Git")
        #       "g/" '(magit-displatch :wk "Magit dispatch")
        #       "g." '(magit-file-displatch :wk "Magit file dispatch")
        #       "gb" '(magit-branch-checkout :wk "Switch branch")
        #       "gc" '(:ignore t :wk "Create")
        #       "gcb" '(magit-branch-and-checkout :wk "Create branch and checkout")
        #       "gcc" '(magit-commit-create :wk "Create commit")
        #       "gcf" '(magit-commit-fixup :wk "Create fixup commit")
        #       "gC" '(magit-clone :wk "Clone repo")
        #       "gf" '(:ignore t :wk "Find")
        #       "gfc" '(magit-show-commit :wk "Show commit")
        #       "gff" '(magit-find-file :wk "Magit find file")
        #       "gfg" '(magit-find-git-config-file :wk "Find gitconfig file")
        #       "gF" '(magit-fetch :wk "Git fetch")
        #       "gg" '(magit-status :wk "Magit status")
        #       "gi" '(magit-init :wk "Initialize git repo")
        #       "gl" '(magit-log-buffer-file :wk "Magit buffer log")
        #       "gr" '(vc-revert :wk "Git revert file")
        #       "gs" '(magit-stage-file :wk "Git stage file")
        #       "gt" '(git-timemachine :wk "Git time machine")
        #       "gu" '(magit-stage-file :wk "Git unstage file"))
        #
        #     (airi/leader-keys
        #        "h" '(:ignore t :wk "Help")
        #        "hf" '(describe-function :wk "Describe function")
        #        "hv" '(describe-variable :wk "Describe variable"))
        #
        #     (airi/leader-keys
        #        "o" '(:ignore t :wk "ORG Stuff")
        #        "oa" '(org-agenda :wk "ORG Agenda")
        #        "oT" '(org-babel-tangle :wk "Tangle ORG File")
        #        "ot" '(org-todo :wk "Toggle TODO"))
        #
        #     (airi/leader-keys
        #       "s" '(:ignore t :wk "Search")
        #       "SPC" '(ibuffer :wk "List Buffers")
        #       "sf" '(find-file :wk "Search File")
        #       "/" '(deadgrep :wk "Search by Grep in the current buffer")
        #       "sg" '(deadgrep :wk "Search by Grep in the whole project"))
        #
        #     (airi/leader-keys
        #       "t" '(:ignore t :wk "Toggle")
        #       "td" '(treemacs :wk "Toggle treemacs")
        #       "te" '(eshell-toggle :wk "Toggle eshell")
        #       "tl" '(display-line-numbers-mode :wk "Toggle line numbers")
        #       "tr" '(rainbow-mode :wk "Toggle rainbow mode")
        #       "tt" '(visual-line-mode :wk "Toggle truncated lines")
        #       "tv" '(vterm-toggle :wk "Toggle vterm"))
        #
        #     (airi/leader-keys
        #       "w" '(:ignore t :wk "Windows")
        #       ;; Window splits
        #       "wc" '(evil-window-delete :wk "Close window")
        #       "wn" '(evil-window-new :wk "New window")
        #       "ws" '(evil-window-split :wk "Horizontal split window")
        #       "wv" '(evil-window-vsplit :wk "Vertical split window")
        #       ;;Window motions
        #       "wh" '(evil-window-left :wk "Window left")
        #       "wj" '(evil-window-down :wk "Window down")
        #       "wk" '(evil-window-up :wk "Window up")
        #       "wl" '(evil-window-right :wk "Window right")
        #       "ww" '(evil-window-next :wk "Goto next window"))
        #   '';
        # };

        # Which Key
        which-key = {
          enable = true;
          diminish = [ "which-key-mode" ];
          init = ''(which-key-mode)'';
          config = ''(setq which-key-idle-delay 0.3)'';
        };

        # UI Stuff
        doom-themes = {
          enable = true;
          config = ''
            ;; Global settings (defaults)
            (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
                  doom-themes-enable-italic t) ; if nil, italics is universally disabled
            (load-theme 'doom-one t)
            ;; Enable flashing mode-line on errors
            (doom-themes-visual-bell-config)
            ;; Enable custom neotree theme (all-the-icons must be installed!)
            (doom-themes-neotree-config)
            ;; or for treemacs users
            (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
            (doom-themes-treemacs-config)
            ;; Corrects (and improves) org-mode's native fontification.
            (doom-themes-org-config)
          '';
        };
        doom-modeline = {
          enable = true;
          init = ''(doom-modeline-mode 1)'';
          config = ''
            (setq doom-modeline-minor-modes t)
          '';
        };
        centered-cursor-mode = {
          enable = true;
          config = ''(global-centered-cursor-mode)'';
        };

        # ORG Mode
        org-modern = {
          enable = true;
          hook = [
            "(org-mode . org-modern-mode)"
            "(org-agenda-finalize . org-modern-agenda)"
          ];
          config = ''
            (set-face-attribute 'default nil :family "Iosevka q SemiBold")
            (set-face-attribute 'variable-pitch nil :family "Iosevka q")
            (set-face-attribute 'org-modern-symbol nil :family "Iosevka q SemiBold")
            ;; Add frame borders and window dividers
            (modify-all-frames-parameters
             '((right-divider-width . 20)
               (internal-border-width . 20)))
            (dolist (face '(window-divider
                            window-divider-first-pixel
                            window-divider-last-pixel))
              (face-spec-reset-face face)
              (set-face-foreground face (face-attribute 'default :background)))
            (set-face-background 'fringe (face-attribute 'default :background))

            (setq org-auto-align-tags nil
                  org-tags-column 0
                  org-catch-invisible-edits 'show-and-error
                  org-special-ctrl-a/e t
                  org-insert-heading-respect-content t

                  ;; Org styling, hide markup etc.
                  org-hide-emphasis-markers t
                  org-pretty-entities t
                  org-ellipsis "…"

                  ;; Agenda styling
                  org-agenda-tags-column 0
                  org-agenda-block-separator ?─
                  org-agenda-time-grid '((daily today require-timed)
                                        (800 1000 1200 1400 1600 1800 2000)
                                        " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
                  org-agenda-current-time-string
                  "◀── now ─────────────────────────────────────────────────")
          '';
        };
        toc-org = {
          enable = true;
          command = [ "toc-org-enable" ];
          hook = [ "(org-mode . toc-org-enable)" ];
        };
        org-bullets = {
          enable = true;
          hook = [ "(org-mode . (lambda () (org-bullets-mode 1)))" ];
        };
        org-tempo.enable = true;

        # Treesitter
        tree-sitter = {
          enable = true;
          diminish = [ "tree-sitter-mode" ];
          config = ''
            (global-tree-sitter-mode)
          '';
        };
        tree-sitter-langs = {
          enable = true;
          after = [ "tree-sitter" ];
          config = ''
            (add-hook 'prog-mode-hook #'tree-sitter-hl-mode)
          '';
        };

        # Misc
        yasnippet = {
          enable = true;
          command = [
            "yas-global-mode"
            "yas-minor-mode"
            "yas-expand-snippet"
          ];
          hook = [
            # Yasnippet interferes with tab completion in ansi-term.
            "(term-mode . (lambda () (yas-minor-mode -1)))"
          ];
          config = "(yas-global-mode 1)";
        };

        yasnippet-snippets = {
          enable = true;
          after = [ "yasnippet" ];
        };

        magit = {
          enable = true;
          command = [ "magit-project-status" ];
          bind = {
            "C-c g" = "magit-status";
          };
          config = ''
            (setq forge-add-pullreq-refspec 'ask)
            (add-to-list 'git-commit-style-convention-checks
                         'overlong-summary-line)
          '';
        };

        deadgrep = {
          enable = true;
          bind = {
            "M-f" = "deadgrep";
          };
          config = ''
            (setq deadgrep-executable "${pkgs.ripgrep}/bin/rg")
          '';
        };

        direnv = {
          enable = true;
          config = ''(direnv-mode)'';
        };

        saveplace = {
          enable = true;
          defer = 1;
          config = ''
            (setq-default save-place t)
            (setq save-place-file (locate-user-emacs-file "places"))
          '';
        };

        # More helpful buffer names. Built-in.
        uniquify = {
          enable = true;
          defer = 5;
          config = ''
            (setq uniquify-buffer-name-style 'post-forward)
          '';
        };

        c-ts-mode.enable = true;
        lsp-clangd = {
          enable = true;
          defer = true;
          hook = [
            "(c-ts-mode . airi-lsp)"
            "(c-or-c++-ts-mode . airi-lsp)"
            "(c++-ts-mode . airi-lsp)"
          ];
        };

        cmake-ts-mode.enable = true;
        lsp-cmake = {
          enable = true;
          defer = true;
          hook = [ "(cmake-ts-mode . airi-lsp)" ];
        };

        haskell-mode = {
          enable = true;
          mode = [
            ''("\\.hs\\'" . haskell-mode)''
            ''("\\.hsc\\'" . haskell-mode)''
            ''("\\.c2hs\\'" . haskell-mode)''
            ''("\\.cpphs\\'" . haskell-mode)''
            ''("\\.lhs\\'" . haskell-literate-mode)''
          ];
          hook = [ "(haskell-mode . subword-mode)" ];
          bindLocal.haskell-mode-map = {
            "C-c C-l" = "haskell-interactive-bring";
          };
          config = ''
            (setq tab-width 2)

            (setq haskell-process-log t
                  haskell-notify-p t)

            (setq haskell-process-args-cabal-repl
                  '("--ghc-options=+RTS -M500m -RTS -ferror-spans -fshow-loaded-modules"))
          '';
        };
        lsp-haskell = {
          enable = true;
          defer = true;
          hook = [ "(haskell-mode . airi-lsp)" ];
        };

        lsp-kotlin = {
          enable = true;
          hook = [ "(kotlin-mode . airi-lsp)" ];
        };

        purescript-mode.enable = true;
        lsp-purescript = {
          enable = true;
          defer = true;
          hook = [ "(purescript-mode . airi-lsp) " ];
          config = ''
            (setq lsp-purescript-formatter "purs-tidy")
          '';
        };

        lsp-ui = {
          enable = true;
          command = [ "lsp-ui-mode" ];
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
                  lsp-ui-sideline-show-hover nil
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
          after = [
            "flycheck"
            "lsp-ui"
          ];
        };

        lsp-completion = {
          enable = true;
          after = [ "lsp-mode" ];
          config = ''
            (setq lsp-completion-enable-additional-text-edit nil)
          '';
        };

        lsp-diagnostics = {
          enable = true;
          after = [ "lsp-mode" ];
        };

        lsp-lens = {
          enable = true;
          command = [ "lsp-lens--enable" ];
          after = [ "lsp-mode" ];
        };

        lsp-mode = {
          enable = true;
          command = [ "lsp" ];
          after = [
            "company"
            "flycheck"
          ];
          bindLocal = {
            lsp-mode-map = {
              "C-c f r" = "lsp-find-references";
              "C-r a" = "lsp-execute-code-action";
              "C-r f" = "lsp-format-buffer";
              "C-r g" = "lsp-format-region";
              "C-r l" = "lsp-avy-lens";
              "C-r r" = "lsp-rename";
            };
          };
          init = ''
            (setq lsp-keymap-prefix "C-r l")
          '';
          config = ''
            (setq lsp-diagnostics-provider :flycheck
                  lsp-eldoc-render-all nil
                  lsp-headerline-breadcrumb-enable nil
                  lsp-modeline-code-actions-enable nil
                  lsp-modeline-diagnostics-enable nil
                  lsp-modeline-workspace-status-enable nil
                  lsp-lens-enable t
                  lsp-enable-on-type-formatting nil)
          '';
        };

        python-ts-mode.enable = true;
        lsp-pylsp = {
          enable = true;
          defer = true;
          hook = [ "(python-ts-mode . airi-lsp)" ];
        };

        rust-ts-mode.enable = true;
        lsp-rust = {
          enable = true;
          defer = true;
          hook = [ "(rust-ts-mode . airi-lsp)" ];
        };

        lsp-treemacs = {
          enable = true;
          after = [ "lsp-mode" ];
          command = [ "lsp-treemacs-errors-list" ];
        };
      };
    };
  };
}

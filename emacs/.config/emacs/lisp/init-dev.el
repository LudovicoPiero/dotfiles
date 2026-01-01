;;; init-dev.el --- Coding & LSP -*- lexical-binding: t; -*-

;; -- LANGUAGES & MODES --

(use-package nix-mode
  :mode "\\.nix\\'"
  :general
  (my-local-leader-def
    :keymaps 'nix-mode-map
    "b" #'nix-build-buffer))

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package lua-mode
  :mode "\\.lua\\'")

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package go-ts-mode
  :ensure nil
  :straight nil
  :general
  (my-local-leader-def
    :keymaps 'go-ts-mode-map
    "t" #'go-test-current-test
    "r" #'go-run))

(use-package c++-ts-mode
  :ensure nil
  :straight nil
  :general
  (my-local-leader-def
    :keymaps '(c-mode-map c++-mode-map c++-ts-mode-map)
    "c" #'compile
    "d" #'gdb))

;; -- TOOLS --
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  :general
  (my-leader-def
    "i"   '(:ignore t :which-key "insert")
    "is"  '(yas-insert-snippet :which-key "insert snippet")
    "in"  '(yas-new-snippet :which-key "new snippet")
    "iv"  '(yas-visit-snippet-file :which-key "edit snippet")))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :general
  (my-leader-def
    "g"   '(:ignore t :which-key "git")
    "gg"  '(magit-status :which-key "status")
    "gf"  '(magit-file-dispatch :which-key "file dispatch")
    "gb"  '(magit-blame :which-key "blame")
    "gd"  '(magit-diff-buffer-file :which-key "diff buffer")))

(use-package corfu
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode) ; Enable documentation popups
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-quit-no-match nil)
  (corfu-popupinfo-delay 0.2) ; Fast popup delay
  (corfu-popupinfo-max-width 70)
  :general
  (general-def
    :keymaps 'corfu-map
    "TAB" #'corfu-next
    [tab] #'corfu-next
    "S-TAB" #'corfu-previous
    [backtab] #'corfu-previous))

;; --- ICONS (Kind Icon) ---
;; Adds VSCode-like icons to the completion menu
(use-package kind-icon
  :ensure t
  :after corfu
  :custom
  (kind-icon-default-style
   '(:padding 0 :stroke 0 :margin 0 :radius 0 :height 0.8 :scale 1.0))
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package eglot
  :hook
  ((nix-mode python-ts-mode go-ts-mode rust-ts-mode c++-ts-mode lua-mode js-ts-mode) . eglot-ensure)
  :commands (eglot-rename eglot-code-actions eglot-format)
  :config
  ;; -- Server Configuration --
  (add-to-list 'eglot-server-programs '((python-mode python-ts-mode) . ("basedpyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs '(lua-mode . ("emmylua-ls")))
  (add-to-list 'eglot-server-programs '((go-mode go-ts-mode) . ("gopls")))
  (add-to-list 'eglot-server-programs '((rust-mode rust-ts-mode) . ("rust-analyzer")))
  (add-to-list 'eglot-server-programs '((c++-mode c++-ts-mode) . ("clangd")))

  ;; Configure Eglot logging
  ;; :size 0 disables logging (improves performance)
  ;; :format 'full or 'lisp usually
  (setq eglot-events-buffer-config '(:size 0 :format full))

  :general
  ;; Buffer-local keys (active only in eglot buffers)
  (general-def
    :keymaps 'eglot-mode-map
    "C-c l r" #'eglot-rename
    "C-c l a" #'eglot-code-actions
    "C-c l d" #'eldoc
    "C-c l f" #'eglot-format)

  ;; Global Leader Keys for LSP
  (my-leader-def
    "c"   '(:ignore t :which-key "code")
    "ca"  '(eglot-code-actions :which-key "code actions")
    "cr"  '(eglot-rename :which-key "rename")
    "cd"  '(eldoc :which-key "doc info")))

;; --- PERFORMANCE: Eglot Booster ---
;; Uses the external 'emacs-lsp-booster' binary
;; to convert massive JSON responses into bytecode.
(use-package eglot-booster
  :straight (:type git :host github :repo "jdtsmith/eglot-booster")
  :after eglot
  :config
  (eglot-booster-mode))

(use-package apheleia
  :commands (apheleia-format-buffer)
  :config
  (apheleia-global-mode +1)
  (setq apheleia-on-save nil)
  :general
  (general-def
    "C-c f" #'apheleia-format-buffer)
  (my-leader-def
    "cf" '(apheleia-format-buffer :which-key "format buffer")))

(use-package flymake
  :commands (flymake-goto-next-error flymake-goto-prev-error flymake-show-buffer-diagnostics)
  :general
  ;; Quick navigation with Alt-n/p
  (general-def
    "M-n" #'flymake-goto-next-error
    "M-p" #'flymake-goto-prev-error)

  ;; Leader keys
  (my-leader-def
    "x"   '(:ignore t :which-key "diagnostics")
    "xx"  '(consult-flymake :which-key "list errors")
    "xn"  '(flymake-goto-next-error :which-key "next error")
    "xp"  '(flymake-goto-prev-error :which-key "prev error")
    "xb"  '(flymake-show-buffer-diagnostics :which-key "buffer diagnostics")))

;; --- GIT GUTTER (Diff-hl) ---
;; Shows uncommitted changes in the sidebar (fringe)
(use-package diff-hl
  :ensure t
  :hook ((dired-mode . diff-hl-dired-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (global-diff-hl-mode)
  ;; Show changes on the fly (don't wait for save)
  (diff-hl-flydiff-mode))

;; --- Vterm ---
(use-package vterm
  :ensure t
  :commands vterm
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-timer-delay nil))

(use-package vterm-toggle
  :ensure t
  :config
  (setq vterm-toggle-fullscreen-p nil)
  :general
  (my-leader-def
    "o"   '(:ignore t :which-key "terminal")
    "ot" '(vterm-toggle :which-key "terminal toggle")
    "oT" '(vterm :which-key "terminal full")))

(provide 'init-dev)

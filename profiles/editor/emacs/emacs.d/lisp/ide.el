(use-package company
  :commands company-tng-configure-default
  :custom
  ;; delay to start completion
  (company-idle-delay 0)
  ;; nb of chars before triggering completion
  (company-minimum-prefix-length 1)

  :config
  ;; enable company-mode in all buffers
  (global-company-mode)

  :bind
  ;; use <C> instead of <M> to navigate completions
  (:map company-active-map
        ("M-n" . nil)
        ("M-p" . nil)
        ("C-n" . #'company-select-next)
        ("C-p" . #'company-select-previous)))

(use-package projectile
  :commands projectile-mode
  :init
  (projectile-mode +1)
  ;; :config
  ;; (counsel-projectile-mode)
  :bind
  (:map projectile-mode-map
        ;; Not sure I want to use Super in emacs, since I use it a lot in gnome
        ;; ("s-p" . projectile-command-map)
        ("C-c p" . projectile-command-map)))

(use-package counsel-projectile
  :init (counsel-projectile-mode +1))

(use-package lsp-mode
  :commands lsp
  :diminish lsp-mode
  :hook
  (nix-mode . lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-nix
  :ensure lsp-mode
  :after (lsp-mode)
  :demand t
  :custom
  (lsp-nix-nil-formatter ["alejandra"]))

;; (use-package nix-mode
;;   :hook (nix-mode . lsp-deferred)
;;   :ensure t)

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package flycheck
  :commands global-flycheck-mode
  :init
  (setq flycheck-mode-globals '(not rust-mode rustic-mode))
  (global-flycheck-mode))

(use-package direnv
  :config (direnv-mode))

;; Allows to see which commands are being called:
;; - command-log-mode
;; - clm/open-command-log-buffer
(use-package command-log-mode)

;; (use-package rustic
;;   :config
;;   (setq rustic-lsp-server 'rust-analyzer)
;;   (unbind-key "C-c C-c C-t" rustic-mode-map)
;;   ;; when passing custom test args with rustic-test-arguments, we need
;;   ;; to run rustic-cargo-test-rerun instead of rustic-cargo-test
;;   ;;
;;   ;; To pass custom test args, add this to .dir-locals.el:
;;   ;; ((rustic-mode . ((rustic-test-arguments . "-- --skip integration"))))
;;   :bind (("C-c C-c C-t" . rustic-cargo-test-rerun)))

(use-package format-all
  :hook
  ((nix-mode . format-all-mode)
    (python-mode . format-all-mode)
    (format-all-mode-hook . format-all-ensure-formatter))
  :config
  (custom-set-variables
    '(format-all-formatters (quote (("Python" black)
                                    ("Nix" alejandra))))))

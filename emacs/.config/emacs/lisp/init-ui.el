;;; init-ui.el --- Visuals -*- lexical-binding: t; -*-

(set-face-attribute 'default nil :font "Iosevka" :height 140)

(use-package catppuccin-theme
  :init
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin :no-confirm)
  :general
  (my-leader-def
    "tt" #'consult-theme))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35)
  (setq doom-modeline-bar-width 4)
  (setq doom-modeline-hud nil)
  (setq doom-modeline-window-width-limit fill-column)
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-state-icon t)
  (setq doom-modeline-buffer-modification-icon t)
  (setq doom-modeline-minor-modes nil)
  (setq doom-modeline-enable-word-count nil)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-indent-info nil)
  (setq doom-modeline-checker-simple t)
  (setq doom-modeline-vcs-max-length 12)
  (setq doom-modeline-lsp t))

(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Shows the actual color background for hex codes (e.g., #ffffff)
(use-package rainbow-mode
  :hook (prog-mode . rainbow-mode))

;; UI Toggles
(my-leader-def
  "t"   '(:ignore t :which-key "toggle")
  "tl"  #'display-line-numbers-mode
  "tw"  #'toggle-word-wrap)

;; --- NEW: Zoom & Window Resizing ---
(my-leader-def
  ;; Zoom (Text Scale)
  "z"   '(:ignore t :which-key "zoom")
  "z+"  #'text-scale-increase
  "z-"  #'text-scale-decrease
  "z0"  #'(lambda () (interactive) (text-scale-set 0))

  ;; Window Resizing (Doom/Vim Style)
  "w"   '(:ignore t :which-key "window")
  "w+"  #'enlarge-window-horizontally
  "w-"  #'shrink-window-horizontally
  "w="  #'balance-windows
  "wd"  #'delete-window
  "wm"  #'delete-other-windows  ; Maximize current
  "ws"  #'split-window-below
  "wv"  #'split-window-right)

(provide 'init-ui)

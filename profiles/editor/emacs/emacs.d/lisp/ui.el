;; Disable things
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Set a font
(add-to-list 'default-frame-alist
              '(font . "Iosevka Nerd Font-10"))

;; set splash screen
(setq inhibit-startup-screen nil)

;; Make *scratch* buffer blank
(setq initial-scratch-message "")

;; use a dark theme
(load-theme 'dracula t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package all-the-icons)

;; Treemacs
(use-package treemacs-all-the-icons)

(use-package treemacs
  :config
  (setq treemacs-show-cursor nil)
  (treemacs-load-theme "all-the-icons")
  :bind
  (("C-t" . treemacs)))

(use-package treemacs-evil
  :after treemacs evil
  :bind
    (("M-l" . 'evil-window-right)))

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-magit
  :after treemacs magit)

(use-package which-key
  :defer 0.1
  :init
  ;; Silence warning (:defer causes byte compile warnings)
  (declare-function which-key-prefix-then-key-order "which-key")
  (declare-function which-key-mode "which-key")

  (setq which-key-sort-order #'which-key-prefix-then-key-order
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-idle-delay 0.5)
  :config
  (which-key-mode +1))

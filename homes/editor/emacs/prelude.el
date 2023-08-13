;;; prelude.el --- Emacs Config Powered by Rycee's emacs-init

;;; Commentary:
;;; More info : https://gitlab.com/rycee/nur-expressions/-/blob/master/hm-modules/emacs-init.nix

;;; Code:

(custom-set-variables
  '(inhibit-startup-screen t))
;; Set a font
(add-to-list 'default-frame-alist
              '(font . "Iosevka q Semibold 15"))
(column-number-mode 1)
(global-auto-revert-mode)
(global-display-line-numbers-mode)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default whitespace-style
              '(face
                tabs
                spaces
                trailing
                lines-tail
                newline
                missing-newline-at-eof
                space-before-tab
                indentation
                empty
                space-after-tab
                space-mark
                tab-mark
                newline-mark))

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

(elcord-mode t)
(setq elcord-use-major-mode-as-main-icon 't
      elcord-quiet 't)

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

;; Evil Mode
(setq evil-want-integration t
      evil-want-keybinding nil
      evil-undo-system 'undo-tree
      evil-respect-visual-line-mode t)
(evil-mode t)
(evil-collection-init)

;;; prelude.el ends here

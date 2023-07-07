(custom-set-variables
  '(inhibit-startup-screen t))
;; Set a font
(add-to-list 'default-frame-alist
              '(font . "Iosevka Comfy 15"))
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

;; Set Backup Directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying      t  ; Don't de-link hard links
      version-control        t  ; Use version numbers on backups
      delete-old-versions    t  ; Automatically delete excess backups:
      kept-new-versions      10 ; how many of the newest versions to keep
      kept-old-versions      5) ; and how many of the old

;; Long text goes below
(global-visual-line-mode t)

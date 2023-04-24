;; Disable some GUI distractions. We set these manually to avoid starting
;; the corresponding minor modes.
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Set up fonts early.
(add-to-list 'default-frame-alist
'(font . "Iosevka Nerd Font 15"))


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

;; Long text goes below
(global-visual-line-mode t)


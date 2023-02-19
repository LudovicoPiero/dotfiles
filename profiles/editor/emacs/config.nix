''
  ;; Disable things
  (menu-bar-mode -1)
  (toggle-scroll-bar -1)
  (tool-bar-mode -1)

  ;; set splash screen
  (setq inhibit-startup-screen nil)

  ;;; UNDO
  ;; Vim style undo not needed for emacs 28
  (use-package undo-fu)

  ;;; Vim Bindings
  (use-package evil
    :demand t
    :bind (("<escape>" . keyboard-escape-quit))
    :init
    ;; allows for using cgn
    ;; (setq evil-search-module 'evil-search)
    (setq evil-want-keybinding nil)
    ;; no vim insert bindings
    (setq evil-undo-system 'undo-fu)
    :config
    (evil-mode 1))

  ;;; Vim Bindings Everywhere else
  (use-package evil-collection
    :after evil
    :config
    (setq evil-want-integration t)
    (evil-collection-init))

  ;; use a dark theme
  (load-theme 'catppuccin-mocha t)

  ;; Set a font
  (add-to-list 'default-frame-alist
              '(font . "Iosevka Nerd Font-10"))

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
''

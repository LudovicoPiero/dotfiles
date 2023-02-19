;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)

;;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (setq evil-symbol-word-search t)
  (evil-select-search-module 'evil-search-module 'evil-search)
  (define-key evil-normal-state-map "s" nil)
  (define-key evil-normal-state-map (kbd "ss") 'evil-window-split)
  (define-key evil-normal-state-map (kbd "sv") 'evil-window-vsplit)
  (define-key evil-normal-state-map (kbd "sr") 'evil-window-rotate-downwards)

  (define-key evil-normal-state-map (kbd "M-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "M-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "M-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "M-l") 'evil-window-right)

  (define-key evil-normal-state-map (kbd "C-M-h") 'evil-window-move-far-left)
  (define-key evil-normal-state-map (kbd "C-M-j") 'evil-window-move-very-bottom)
  (define-key evil-normal-state-map (kbd "C-M-k") 'evil-window-move-very-top)
  (define-key evil-normal-state-map (kbd "C-M-l") 'evil-window-move-far-right)

  (define-key evil-normal-state-map (kbd "C-=") 'balance-windows)
  (define-key evil-normal-state-map (kbd "C-s z") 'delete-other-windows))

;;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

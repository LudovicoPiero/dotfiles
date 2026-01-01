;;; init-keys.el --- Evil & Orphans -*- lexical-binding: t; -*-

;; -- EVIL MODE --
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree)

  ;; No littering
  (setq undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo-tree/" user-emacs-directory)))))

;; -- EVIL COMMENTARY --
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode)
  :general
  (my-leader-def
    "/" #'evil-commentary-line))

;; -- EVIL SURROUND --
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1)
  :general
  (general-def
    :states '(normal visual)
    "gsa" #'evil-surround-region
    "gsd" #'evil-surround-delete
    "gsr" #'evil-surround-change))

;; -- ORPHAN GLOBAL KEYS --
;; Generic functionality that doesn't fit into specific modules
(my-leader-def
  "SPC" #'execute-extended-command
  "TAB" #'mode-line-other-buffer   ; Fast switch to previous buffer (Like Doom 'SPC TAB')
  "."   #'find-file                ; Fast file find (Like Doom 'SPC .')

  ;; --- q: QUIT / SESSION ---
  "q"   '(:ignore t :which-key "quit/session")
  "qq"  #'save-buffers-kill-terminal
  "qR"  #'restart-emacs

  ;; --- f: FILES (Generic) ---
  "f"   '(:ignore t :which-key "file")
  "ff"  #'find-file
  "fs"  #'save-buffer
  "fc"  '((lambda () (interactive) (find-file (expand-file-name "init-keys.el" (concat user-emacs-directory "lisp/")))) :which-key "edit keys")
  "fy"  #'(lambda () (interactive) (kill-new (buffer-file-name))) ; Yank file path

  ;; --- b: BUFFERS (Generic) ---
  "b"   '(:ignore t :which-key "buffer")
  "bk"  #'kill-current-buffer
  "br"  #'revert-buffer
  "bn"  #'next-buffer
  "bp"  #'previous-buffer
  "bY"  #'(lambda () (interactive) (kill-new (buffer-name)))       ; Yank buffer name
  "bB"  #'switch-to-buffer                                         ; Fallback switch
  "bN"  #'make-empty-file-with-process-buffer)                     ; New empty buffer

(provide 'init-keys)

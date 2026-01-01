;;; init-core.el --- Sane Defaults & Helpers -*- lexical-binding: t; -*-

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :custom
  (recentf-auto-cleanup (if (daemonp) 300 'never))
  (recentf-exclude
   (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
         "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
         "\\.7z$" "\\.rar$"
         "COMMIT_EDITMSG\\'"
         "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
         "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :custom
  (savehist-autosave-interval 600)
  (savehist-additional-variables
   '(kill-ring                        ; clipboard
     register-alist                   ; macros
     mark-ring global-mark-ring       ; marks
     search-ring regexp-search-ring)))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :custom
  (save-place-limit 400))

(use-package smartparens
  :ensure smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :custom
  (auto-revert-interval 3)
  (auto-revert-remote-files nil)
  (auto-revert-use-notify t)
  (auto-revert-avoid-polling nil)
  (auto-revert-verbose t))

(use-package expand-region
  :commands (er/expand-region)
  :general
  (general-def
    "C-=" #'er/expand-region))

(use-package drag-stuff
  :init (drag-stuff-global-mode 1)
  :general
  (general-def
    "M-<up>"   #'drag-stuff-up
    "M-<down>" #'drag-stuff-down))

(use-package stripspace
  :hook (after-init . stripspace-global-mode)
  :config (setq stripspace-skip-modes '(markdown-mode org-mode conf-mode))
  :general
  (general-def
    "C-c s" #'stripspace-cleanup))

(use-package vundo
  :commands (vundo)
  :config (setq vundo-glyph-alist vundo-unicode-symbols)
  :general
  (general-def
    "C-x u" #'vundo)
  (my-leader-def
    "u" #'vundo))

(use-package multiple-cursors
  :commands (mc/mark-next-like-this mc/mark-previous-like-this mc/mark-all-like-this mc/edit-lines)
  ;; no-littering handles the list-file location automatically,
  ;; but if you want to be explicit:
  ;; :config (setq mc/list-file (no-littering-expand-var-file-name "mc-lists.el"))
  :general
  (general-def
    "C->"     #'mc/mark-next-like-this
    "C-<"     #'mc/mark-previous-like-this
    "C-c C-<" #'mc/mark-all-like-this
    "C-c m"   #'mc/edit-lines))

(use-package crux
  :commands (crux-move-beginning-of-line crux-smart-kill-line crux-smart-open-line crux-smart-open-line-above crux-delete-file-and-buffer crux-rename-file-and-buffer)
  :general
  (general-def
    "C-a"            #'crux-move-beginning-of-line
    "C-k"            #'crux-smart-kill-line
    "S-<return>"     #'crux-smart-open-line
    "C-S-<return>"   #'crux-smart-open-line-above)

  (my-leader-def
    "fD" #'crux-delete-file-and-buffer
    "fR" #'crux-rename-file-and-buffer))

(use-package which-key
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.3))

;; Use latest Org
(use-package org
  :ensure t)

;; Replaces ugly stars and bullets with nice SVG/Text badges.
(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
  :config
  (setq org-modern-star '("◉" "○" "◈" "◇" "✳" "◆" "▒" "▼" "◀" "▶"))
  (setq org-modern-table-vertical 1)
  (setq org-modern-table-horizontal 0.2)
  (setq org-modern-list '((43 . "➤") (45 . "–") (42 . "•")))
  (setq org-modern-todo-faces
        '(("TODO" :inherit org-todo :color "#ff6c6b" :weight bold)
          ("WAIT" :inherit org-todo :color "#98be65" :weight bold)
          ("DONE" :inherit org-done :color "#51afef" :weight bold))))

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

;; --- BETTER HELP ---
(use-package helpful
  :ensure t
  :general
  (my-leader-def
    "hc" '(helpful-command  :which-key "describe command")
    "hf" '(helpful-callable :which-key "describe function")
    "hv" '(helpful-variable :which-key "describe variable")
    "hk" '(helpful-key      :which-key "describe key")
    "hp" '(helpful-at-point :which-key "describe at point")))

(provide 'init-core)

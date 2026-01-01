;;; pre-early-init.el --- Sane Defaults -*- lexical-binding: t; -*-

;; -- UTF-8 Everywhere --
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Disable the default package.el init to prevent conflicts with Straight
(setq minimal-emacs-package-initialize-and-refresh nil)

;;; Reducing clutter in ~/.emacs.d by redirecting files to ~/.emacs.d/var/
(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
;; Ensure the jail exists
(make-directory user-emacs-directory t)

;; -- Quality of Life --
(setq use-short-answers t)
(setq use-dialog-box nil)
(setq ring-bell-function 'ignore)
(global-auto-revert-mode 1)
(delete-selection-mode 1)

;; -- Dired Tweaks --
(setq dired-listing-switches "-alh --group-directories-first")
(setq dired-kill-when-opening-new-dired-buffer t)
(setq dired-dwim-target t)

;; pre-early-init.el ends here

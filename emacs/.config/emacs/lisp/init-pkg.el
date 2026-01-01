;;; init-pkg.el --- Straight.el Bootstrap -*- lexical-binding: t; -*-

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; -- GENERAL (Keybind Utility) --
;; Loaded early so :general keyword works in all other modules
(use-package general
  :config
  ;; Define the "SPC" leader key
  (general-create-definer my-leader-def
    :prefix "SPC"
    :states '(normal visual motion)
    :keymaps 'override)

  ;; Define "SPC m" for local leader (major mode specific)
  (general-create-definer my-local-leader-def
    :prefix "SPC m"
    :states '(normal visual motion)
    :keymaps 'override))

(provide 'init-pkg)

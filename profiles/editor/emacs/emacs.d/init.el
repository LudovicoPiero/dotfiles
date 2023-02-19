;; Thanks to git@little-dude/dotfiles <3

;; Accept 'y' and 'n' rather than 'yes' and 'no'.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Default is 4k, which is too low for LSP.
(setq read-process-output-max (* 1024 1024))

;; Always show line and column number in the mode line.
(line-number-mode)
(column-number-mode)

;; Use one space to end sentences.
(setq sentence-end-double-space nil)

;; I typically want to use UTF-8.
(prefer-coding-system 'utf-8)

;; Improved handling of clipboard in GNU/Linux and otherwise.
(setq select-enable-clipboard t
  select-enable-primary t
  save-interprogram-paste-before-kill t)



(eval-when-compile
  (require 'use-package))

(load-file "~/.emacs.d/lisp/file.el")
(load-file "~/.emacs.d/lisp/evil.el")
(load-file "~/.emacs.d/lisp/ui.el")
(load-file "~/.emacs.d/lisp/ide.el")


;;; init-nav.el --- Vertico, Consult, Avy -*- lexical-binding: t; -*-

(use-package avy
  :commands (avy-goto-char avy-goto-char-2 avy-goto-word-1)
  :general
  (general-def
    "C-:"   #'avy-goto-char
    "C-'"   #'avy-goto-char-2
    "M-g w" #'avy-goto-word-1))

(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-count 15)
  (setq vertico-resize nil)
  (vertico-mode 1)
  (vertico-mouse-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :commands (consult-buffer consult-ripgrep consult-line consult-find consult-imenu consult-recent-file consult-history consult-yank-pop consult-project-buffer)
  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :general
  ;; Global M-bindings
  (general-def
    "C-x b" #'consult-buffer
    "M-s r" #'consult-ripgrep)

  ;; Leader bindings
  (my-leader-def
    "bb"  #'consult-buffer
    "fr"  #'consult-recent-file

    ;; --- s: SEARCH ---
    "s"   '(:ignore t :which-key "search")
    "ss"  #'consult-line
    "sp"  #'consult-ripgrep
    "sf"  #'consult-find
    "si"  #'consult-imenu
    "sh"  #'consult-history     ; Search command history
    "sk"  #'consult-yank-pop))  ; Search kill-ring (yank history)

(use-package embark
  ;; Embark is an Emacs package that acts like a context menu, allowing
  ;; users to perform context-sensitive actions on selected items
  ;; directly from the completion interface.
  :ensure t
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package project
  :ensure nil
  :straight nil
  :general
  (my-leader-def
    "p"   '(:ignore t :which-key "project")
    ;; Navigation
    "pf"  #'project-find-file                 ; Find file in project
    "pd"  #'project-dired                     ; Open project root in dired
    "pp"  #'project-switch-project            ; Switch to another project
    "pb"  #'consult-project-buffer            ; Switch to buffer in current project

    ;; Actions / Workflow
    "pc"  #'project-compile                   ; Run 'make', 'cargo build', etc.
    "ps"  #'project-find-regexp               ; Grep/Search text in project
    "pr"  #'project-query-replace-regexp      ; Interactive find/replace (Refactoring)
    "pt"  #'project-shell                     ; Open shell in project root
    "pg"  #'magit-project-status              ; Open Magit for this project

    ;; Management
    "pk"  #'project-kill-buffers              ; Kill all project buffers
    "px"  #'project-forget-project            ; Remove project from list (Forget)
    "pD"  #'project-remember-projects-under)) ; Discover new projects

(provide 'init-nav)

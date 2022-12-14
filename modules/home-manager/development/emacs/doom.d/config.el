;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Ludovico Piero"
      user-mail-address "ludovicopiero@pm.me")

(setq doom-font (font-spec :family "UbuntuMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "UbuntuMono Nerd Font" :size 15)
      doom-big-font (font-spec :family "UbuntuMono Nerd Font" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(beacon-mode 1)
(setq doom-theme 'doom-one)

(setq display-line-numbers-type 'relative)

(setq org-directory "~/org/")

(setq shell-file-name "/home/ludovico/.nix-profile/bin/fish"
      vterm-max-scrollback 5000)
(setq shell-history-size 5000
      eshell-buffer-maximum-lines 5000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t
      eshell-destroy-buffer-when-process-dies t
      eshell-visual-commands'("bash" "fish" "htop" "ssh" "top" "zsh"))
(map! :leader
      :desc "Eshell" "e s" #'eshell
      :desc "Eshell popup toggle" "e t" #'+eshell/toggle
      :desc "Counsel eshell history" "e h" #'counsel-esh-history
      :desc "Vterm popup toggle" "v t" #'+vterm/toggle)


;; Discord Presence
(require 'elcord)
(add-hook 'after-init-hook 'elcord-mode)

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

;; Discord Presence
(require 'elcord)
(add-hook 'after-init-hook 'elcord-mode)
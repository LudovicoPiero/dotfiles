(defun magit-custom ()
  (local-unset-key (kbd "<C-tab>")))
(add-hook 'magit-mode-hook #'magit-custom)

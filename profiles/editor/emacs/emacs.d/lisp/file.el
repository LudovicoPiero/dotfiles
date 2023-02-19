;; disable hard tabs
(setq-default indent-tabs-mode nil)
;; default tab width is 4, not 8
(setq-default tab-width 4)
(setq-default tab-always-indent nil)

(put 'downcase-region 'disabled nil)
(setq-default whitespace-style
              '(face
                tabs
                spaces
                trailing
                lines-tail
                newline
                missing-newline-at-eof
                space-before-tab
                indentation
                empty
                space-after-tab
                space-mark
                tab-mark
                newline-mark))

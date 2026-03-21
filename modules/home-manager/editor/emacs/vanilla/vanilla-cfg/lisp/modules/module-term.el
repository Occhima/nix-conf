;;; module-term.el --- Terminal integration -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package vterm
  :commands (vterm vterm-other-window)
  :custom
  (vterm-max-scrollback 10000))

(use-package eat
  :commands (eat eat-project)
  :custom
  (eat-kill-buffer-on-exit t))

(occhima/leadrr
  "a" '(:ignore t :which-key "apps")
  "at" '(:ignore t :which-key "term")
  "att" #'vterm
  "atv" #'vterm-other-window
  "ate" #'eat)

(provide 'module-term)
;;; module-term.el ends here

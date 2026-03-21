;;; core-editing.el --- Editing behavior and generic helpers -*- lexical-binding: t; -*-

(electric-pair-mode 1)
(delete-selection-mode 1)
(global-auto-revert-mode 1)
(setq auto-save-default t
      make-backup-files t
      sentence-end-double-space nil)

(use-package jinx
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package goggles
  :hook ((prog-mode text-mode) . goggles-mode)
  :custom
  (goggles-pulse t))

(provide 'core-editing)
;;; core-editing.el ends here

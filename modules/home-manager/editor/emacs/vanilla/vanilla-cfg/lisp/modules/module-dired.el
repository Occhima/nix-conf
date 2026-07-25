;;; module-dired.el --- Dired and Dirvish -*- lexical-binding: t; -*-

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  (delete-by-moving-to-trash t)
  :config
  (setq dired-listing-switches "-alh --group-directories-first"))

(use-package dirvish
  :after dired
  :init
  (dirvish-override-dired-mode 1)
  :custom
  (dirvish-attributes '(vc-state subtree-state nerd-icons collapse file-time file-size))
  (dirvish-quick-access-entries
   `(("h" "~/" "Home")
     ("e" ,user-emacs-directory "Emacs")
     ("m" "~/Dropbox/projects/learning/usp/masters_degree/" "Masters")
     ("l" "~/Dropbox/projects/library/" "Library")
     ("d" "~/Downloads/" "Downloads")
     ("t" "~/.local/share/Trash/files/" "Trash")))
  (dirvish-side-width 32)
  (dirvish-mode-line-format
   '(:left (sort symlink) :right (omit yank index)))
  :config
  (setq dirvish-use-mode-line 'global))

(provide 'module-dired)
;;; module-dired.el ends here

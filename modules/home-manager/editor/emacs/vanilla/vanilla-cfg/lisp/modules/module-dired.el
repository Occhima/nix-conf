;;; module-dired.el --- Dired and Dirvish -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-dwim-target t)
  (delete-by-moving-to-trash t)
  :config
  (setq dired-listing-switches "-alh --group-directories-first"))

(use-package diredfl
  :hook ((dired-mode . diredfl-mode)
         (dirvish-directory-view-mode . diredfl-mode)))

(use-package dirvish
  :demand t
  :custom
  (dirvish-attributes '(vc-state subtree-state nerd-icons collapse file-time file-size))
  (dirvish-subtree-always-show-state t)
  (dirvish-hide-details '(dirvish dirvish-side))
  (dirvish-hide-cursor '(dirvish dirvish-side))
  (dirvish-reuse-session 'open)
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
  (dirvish-override-dired-mode 1)
  (dirvish-side-follow-mode 1)
  (setq dirvish-use-mode-line 'global)
  (general-def
    :states 'normal
    :keymaps 'dirvish-mode-map
    "?" #'dirvish-dispatch
    "q" #'dirvish-quit
    "b" #'dirvish-quick-access
    "f" #'dirvish-file-info-menu
    "p" #'dirvish-yank
    "S" #'dirvish-quicksort
    "F" #'dirvish-layout-toggle
    "z" #'dirvish-history-jump
    "gh" #'dirvish-subtree-up
    "gl" #'dirvish-subtree-toggle
    "h" #'dired-up-directory
    "l" #'dired-find-file
    "TAB" #'dirvish-subtree-toggle
    "[h" #'dirvish-history-go-backward
    "]h" #'dirvish-history-go-forward
    "M-n" #'dirvish-narrow
    "M-m" #'dirvish-mark-menu
    "M-s" #'dirvish-setup-menu
    "M-e" #'dirvish-emerge-menu
    "yl" #'dirvish-copy-file-true-path
    "yn" #'dirvish-copy-file-name
    "yp" #'dirvish-copy-file-path
    "yy" #'dired-do-copy))

(provide 'module-dired)
;;; module-dired.el ends here

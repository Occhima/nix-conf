;;; module-project.el --- project.el workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package project
  :ensure nil
  :custom
  (project-switch-commands
   '((project-find-file "Find file")
     (project-find-regexp "Find regexp")
     (project-dired "Dired")
     (project-shell "Shell")
     (project-eshell "Eshell"))))

(use-package consult
  :after project
  :bind
  (("C-c p f" . project-find-file)
   ("C-c p p" . project-switch-project)
   ("C-c p g" . consult-ripgrep)
   ("C-c p b" . consult-project-buffer)))

(occhima/leadrr
  "p" '(:ignore t :which-key "project")
  "pp" #'project-switch-project
  "pf" #'project-find-file
  "pg" #'consult-ripgrep
  "pb" #'consult-project-buffer
  "pd" #'project-dired)

(provide 'module-project)
;;; module-project.el ends here

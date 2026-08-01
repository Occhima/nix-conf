;;; module-project.el --- project.el workflow -*- lexical-binding: t; -*-

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project" ".projectile"))
  (project-switch-commands
   '((project-find-file "Find file")
     (project-find-regexp "Find regexp")
     (project-dired "Dired")
     (project-shell "Shell")
     (project-eshell "Eshell"))))

(use-package consult
  :ensure nil
  :defer t
  :after project
  :bind
  (("C-c p f" . project-find-file)
   ("C-c p p" . project-switch-project)
   ("C-c p g" . consult-ripgrep)
   ("C-c p b" . consult-project-buffer)))

(provide 'module-project)
;;; module-project.el ends here

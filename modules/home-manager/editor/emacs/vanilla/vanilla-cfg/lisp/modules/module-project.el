;;; module-project.el --- project.el workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(defconst occhima/project-search-path '("~/Dropbox/projects"))

(defun occhima/project-add (directory)
  "Remember the project rooted at DIRECTORY."
  (interactive "DAdd project: ")
  (if-let* ((project (project-current nil directory)))
      (progn
        (project-remember-project project)
        (message "Added project %s" (project-root project)))
    (user-error "No project found at %s" directory)))

(defun occhima/project-discover ()
  "Remember every project below `occhima/project-search-path'."
  (interactive)
  (dolist (directory occhima/project-search-path)
    (when (file-directory-p directory)
      (project-remember-projects-under directory))))

(defun occhima/project-edit-dir-locals ()
  "Open the current project's .dir-locals.el."
  (interactive)
  (find-file (expand-file-name ".dir-locals.el" (project-root (project-current t)))))

(defun occhima/project-recent-file ()
  "Open a recently visited file from the current project."
  (interactive)
  (let* ((root (expand-file-name (project-root (project-current t))))
         (files (seq-filter (lambda (file) (string-prefix-p root (expand-file-name file)))
                            recentf-list)))
    (find-file (expand-file-name
                (completing-read "Recent project file: "
                                 (mapcar (lambda (file) (file-relative-name file root)) files)
                                 nil t)
                root))))

(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project" ".projectile"))
  (project-switch-commands
   '((project-find-file "Find file")
     (project-find-regexp "Find regexp")
     (project-dired "Dired")
     (project-shell "Shell")
     (project-eshell "Eshell")))
  :config
  (unless (file-exists-p project-list-file)
    (occhima/project-discover)))

(occhima/leader
  "p !" '(project-shell-command :wk "Run cmd in project root")
  "p &" '(project-async-shell-command :wk "Async cmd in project root")
  "p a" '(occhima/project-add :wk "Add project")
  "p C" '(recompile :wk "Repeat last command")
  "p D" '(occhima/project-discover :wk "Discover projects")
  "p e" '(occhima/project-edit-dir-locals :wk "Edit .dir-locals")
  "p F" '(project-or-external-find-file :wk "Find file incl. external")
  "p o" '(find-sibling-file :wk "Find sibling file")
  "p r" '(occhima/project-recent-file :wk "Recent project files"))

(provide 'module-project)
;;; module-project.el ends here

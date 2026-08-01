;;; module-dashboard.el --- Startup dashboard -*- lexical-binding: t; -*-

(use-package welcome-dashboard
  :ensure (welcome-dashboard
           :host github
           :repo "konrad1977/welcome-dashboard"
           :files ("welcome-dashboard.el")
           :wait t)
  :demand t
  :init
  (setq welcome-dashboard-title
        (format "Welcome %s. Have a great day!"
                (car (split-string user-full-name)))
        welcome-dashboard-use-nerd-icons t
        welcome-dashboard-show-separator t
        welcome-dashboard-show-file-path t
        welcome-dashboard-path-max-length 75
        welcome-dashboard-min-left-padding 10
        welcome-dashboard-shortcut-spacing 8
        welcome-dashboard-max-number-of-recent-files 7
        welcome-dashboard-max-number-of-projects 5
        welcome-dashboard-max-number-of-todos 5)
  :config
  (welcome-dashboard-create-welcome-hook))

(provide 'module-dashboard)
;;; module-dashboard.el ends here

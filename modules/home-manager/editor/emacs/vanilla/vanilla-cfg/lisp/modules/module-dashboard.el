;;; module-dashboard.el --- Startup dashboard -*- lexical-binding: t; -*-

(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-items '((recents . 7)
                          (projects . 5)
                          (agenda . 5))
        dashboard-projects-backend 'project-el
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  :config
  (dashboard-setup-startup-hook))

(provide 'module-dashboard)
;;; module-dashboard.el ends here

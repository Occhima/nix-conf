;;; module-theme-modeline.el --- Theme and status bar -*- lexical-binding: t; -*-

(use-package doom-themes
  :init
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  :config
  (add-to-list 'custom-theme-load-path
               (expand-file-name "themes" user-emacs-directory))
  (load-theme 'doom-polykai t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package nerd-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :init
  (setq doom-modeline-height 28
        doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-icon (display-graphic-p)
        doom-modeline-minor-modes nil)
  :config
  (doom-modeline-mode 1))

(provide 'module-theme-modeline)
;;; module-theme-modeline.el ends here

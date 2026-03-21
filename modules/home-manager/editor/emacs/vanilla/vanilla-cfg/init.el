;;; init.el --- Vanilla Emacs entrypoint -*- lexical-binding: t; -*-

(defconst occhima/lisp-dir (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "core" occhima/lisp-dir))
(add-to-list 'load-path (expand-file-name "modules" occhima/lisp-dir))

(require 'core-startup)
(require 'core-package-management)
(require 'core-ui)
(require 'core-editing)
(require 'core-evil)
(require 'core-keybinds)
(require 'module-completion)
(require 'module-treesit)
(require 'module-project)
(require 'module-vc-compile)
(require 'module-term)
(require 'module-ai)
(require 'module-dashboard)
(require 'module-theme-modeline)
(require 'module-dired)
(require 'module-org)
(require 'module-org-babel)
(require 'module-latex)
(require 'module-lang-nix)
(require 'module-lang-python)
(require 'module-lang-r)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 64 1024 1024)
                  gc-cons-percentage 0.1)
            (message "Vanilla Emacs ready in %.2fs with %d GCs"
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

(provide 'init)
;;; init.el ends here

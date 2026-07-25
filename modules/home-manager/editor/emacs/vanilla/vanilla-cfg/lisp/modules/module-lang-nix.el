;;; module-lang-nix.el --- Nix language tooling -*- lexical-binding: t; -*-

(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . nix-prettify-mode))

(use-package nix-ts-mode
  :mode ("\\.nix\\'" . nix-ts-mode)
  :hook (nix-ts-mode . eglot-ensure))

(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (nix-mode . eglot-ensure)
         (ess-r-mode . eglot-ensure)
         (LaTeX-mode . eglot-ensure))
  :custom
  (eglot-connect-timeout 120)
  (eglot-autoshutdown t)
  :config
  (add-to-list 'eglot-server-programs
               '((nix-mode nix-ts-mode) . ("nil"))))

(provide 'module-lang-nix)
;;; module-lang-nix.el ends here

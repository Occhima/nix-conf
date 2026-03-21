;;; module-lang-nix.el --- Nix language tooling -*- lexical-binding: t; -*-

(use-package nix-mode
  :mode "\\.nix\\'"
  :hook ((nix-mode . nix-prettify-mode)
         (nix-mode . eglot-ensure)))

(use-package nix-ts-mode
  :ensure nil
  :mode "\\.nix\\'")

(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (python-ts-mode . eglot-ensure)
         (ess-r-mode . eglot-ensure)
         (LaTeX-mode . eglot-ensure))
  :custom
  (eglot-connect-timeout 120)
  (eglot-autoshutdown t)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil"))))

(provide 'module-lang-nix)
;;; module-lang-nix.el ends here

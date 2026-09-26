;;; module-programming.el --- Structural editing and diagnostics -*- lexical-binding: t; -*-

(require 'core-evil)

;; Enabled last so envrc's hook runs before the others that read the environment.
(use-package envrc
  :hook (elpaca-after-init . envrc-global-mode))

(use-package apheleia
  :demand t
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist) 'ruff
        (alist-get 'python-ts-mode apheleia-mode-alist) 'ruff)
  (apheleia-global-mode 1))

(use-package eglot
  :ensure nil
  :custom
  (eglot-connect-timeout 120)
  (eglot-sync-connect 0)
  (eglot-autoshutdown t)
  (eglot-events-buffer-config '(:size 0 :format full)))

(use-package breadcrumb
  :hook (prog-mode . breadcrumb-local-mode))

(use-package eglot-booster
  :ensure (eglot-booster :host github :repo "jdtsmith/eglot-booster")
  :after eglot
  :when (executable-find "emacs-lsp-booster")
  :config
  (eglot-booster-mode 1))

(use-package eldoc-box
  :hook (eglot-managed-mode . eldoc-box-hover-mode))

(use-package combobulate
  :ensure (combobulate
           :host github
           :repo "mickeynp/combobulate")
  :hook ((python-ts-mode . combobulate-mode)
         (js-ts-mode . combobulate-mode)
         (go-ts-mode . combobulate-mode)
         (yaml-ts-mode . combobulate-mode)
         (json-ts-mode . combobulate-mode))
  :custom
  (combobulate-key-prefix "C-c o"))

(use-package flyover
  :ensure (flyover
           :host github
           :repo "konrad1977/flyover")
  :hook (flymake-mode . flyover-mode)
  :custom
  (flyover-checkers '(flymake))
  (flyover-use-theme-colors t)
  (flyover-wrap-messages t))

(occhima/local-leader (emacs-lisp-mode lisp-interaction-mode)
  "e b" '(eval-buffer :wk "Eval buffer")
  "e d" '(eval-defun :wk "Eval defun")
  "e e" '(eval-last-sexp :wk "Eval last sexp")
  "e r" '(eval-region :wk "Eval region")
  "m" '(pp-macroexpand-last-sexp :wk "Macroexpand"))

(use-package markdown-mode
  :mode ("\\.md\\'" . markdown-mode))

(use-package polymode
  :mode ("\\.nix\\'" . occhima/poly-nix-mode)
  :config
  (define-hostmode occhima/nix-ts-hostmode :mode 'nix-ts-mode)

  (define-innermode occhima/nix-bash-innermode
    :mode 'bash-ts-mode
    :head-matcher "# bash\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode occhima/nix-python-innermode
    :mode 'python-ts-mode
    :head-matcher "# python\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode occhima/nix-lua-innermode
    :mode 'lua-ts-mode
    :head-matcher "# lua\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode occhima/nix-json-innermode
    :mode 'json-ts-mode
    :head-matcher "# json\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode occhima/nix-markdown-innermode
    :mode 'markdown-mode
    :head-matcher "# markdown\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-polymode occhima/poly-nix-mode
    :hostmode 'occhima/nix-ts-hostmode
    :innermodes '(occhima/nix-bash-innermode
                  occhima/nix-python-innermode
                  occhima/nix-lua-innermode
                  occhima/nix-json-innermode
                  occhima/nix-markdown-innermode)))

(use-package just-mode
  :mode ("\\(?:J\\|j\\)ustfile\\'" "\\.just\\'")
  :config
  (occhima/local-leader just-mode
    "r" '(justl-exec-recipe :wk "Run recipe")
    "R" '(justl-exec-default-recipe :wk "Run default recipe")
    "j" '(justl :wk "Open Justl")
    "=" '(just-format-buffer :wk "Format buffer")))

(use-package justl
  :ensure (justl :host github :repo "psibi/justl.el")
  :commands (justl justl-exec-recipe justl-exec-default-recipe))

(occhima/leader
  "jj" '(justl :wk "Open Justl")
  "jr" '(justl-exec-recipe :wk "Run recipe"))

(provide 'module-programming)
;;; module-programming.el ends here

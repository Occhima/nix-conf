;;; module-programming.el --- Structural editing and diagnostics -*- lexical-binding: t; -*-

(require 'core-evil)

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
                  occhima/nix-json-innermode
                  occhima/nix-markdown-innermode)))

(use-package just-mode
  :mode ("\\(?:J\\|j\\)ustfile\\'" "\\.just\\'")
  :config
  (occhima/local-leader
    "r" '(justl-exec-recipe :wk "Run recipe")
    "R" '(justl-exec-default-recipe :wk "Run default recipe")
    "j" '(justl :wk "Open Justl")
    "=" '(just-format-buffer :wk "Format buffer")))

(use-package justl
  :ensure (justl :host github :repo "psibi/justl.el")
  :commands (justl justl-exec-recipe justl-exec-default-recipe)
  :config
  (occhima/leader
    "jj" '(justl :wk "Open Justl")
    "jr" '(justl-exec-recipe :wk "Run recipe")))

(provide 'module-programming)
;;; module-programming.el ends here

;;; module-lang-extra.el --- Remaining languages from the Doom config -*- lexical-binding: t; -*-

(require 'core-evil)

;; Built-in tree-sitter modes that do not register themselves in auto-mode-alist.
(dolist (entry '(("\\.go\\'" . go-ts-mode)
                 ("/go\\.mod\\'" . go-mod-ts-mode)
                 ("\\.rs\\'" . rust-ts-mode)
                 ("\\.ts\\'" . typescript-ts-mode)
                 ("\\.tsx\\'" . tsx-ts-mode)
                 ("\\.[cm]?jsx?\\'" . js-ts-mode)
                 ("\\.json\\'" . json-ts-mode)
                 ("\\.ya?ml\\'" . yaml-ts-mode)
                 ("\\.lua\\'" . lua-ts-mode)
                 ("\\.php\\'" . php-ts-mode)
                 ("\\.css\\'" . css-ts-mode)
                 ("\\(?:Dockerfile\\|Containerfile\\)\\'" . dockerfile-ts-mode)))
  (add-to-list 'auto-mode-alist entry))

(dolist (hook '(go-ts-mode-hook
                rust-ts-mode-hook
                js-ts-mode-hook
                typescript-ts-mode-hook
                tsx-ts-mode-hook
                json-ts-mode-hook
                css-ts-mode-hook
                sh-mode-hook
                bash-ts-mode-hook))
  (add-hook hook #'eglot-ensure))

(use-package haskell-mode
  :hook ((haskell-mode . eglot-ensure)
         (haskell-mode . interactive-haskell-mode))
  :custom
  (haskell-interactive-popup-errors nil))

(use-package julia-mode
  :mode "\\.jl\\'")

(use-package julia-repl
  :hook (julia-mode . julia-repl-mode))

(use-package eglot-jl
  :after eglot
  :hook (julia-mode . eglot-ensure)
  :config
  (setq eglot-jl-language-server-project eglot-jl-base)
  (eglot-jl-init))

(use-package scala-ts-mode
  :mode "\\.scala\\'"
  :hook (scala-ts-mode . eglot-ensure))

(use-package web-mode
  :mode ("\\.html?\\'" "\\.vue\\'" "\\.svelte\\'" "\\.jinja2?\\'" "\\.njk\\'")
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2))

(use-package beancount
  :ensure (beancount :host github :repo "beancount/beancount-mode")
  :mode ("\\.beancount\\'" . beancount-mode)
  :hook (beancount-mode . eglot-ensure)
  :config
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(beancount-mode . ("beancount-language-server")))))

(use-package qml-mode
  :mode "\\.qml\\'")

(use-package powershell
  :mode ("\\.ps[dm]?1\\'" . powershell-mode))

(use-package restclient
  :mode ("\\.http\\'" . restclient-mode))

(use-package restclient-jq
  :after restclient)

(occhima/local-leader restclient-mode
  "e" '(restclient-http-send-current :wk "Send request")
  "E" '(restclient-http-send-current-raw :wk "Send raw request")
  "c" '(restclient-copy-curl-command :wk "Copy as curl"))

(occhima/local-leader julia-mode
  "r" '(julia-repl :wk "REPL")
  "e" '(julia-repl-send-region-or-line :wk "Send region/line")
  "b" '(julia-repl-send-buffer :wk "Send buffer"))

(occhima/local-leader beancount-mode
  "b" '(beancount-insert-account :wk "Insert account")
  "c" '(beancount-check :wk "Check")
  "q" '(beancount-query :wk "Query")
  "l" '(beancount-linked :wk "Linked transactions"))

(occhima/local-leader lisp-mode
  "'" '(sly :wk "Sly")
  "c" '(occhima/nyxt-connect :wk "Connect to Nyxt")
  "e" '(sly-eval-last-expression :wk "Eval last sexp")
  "d" '(sly-eval-defun :wk "Eval defun")
  "r" '(sly-eval-region :wk "Eval region")
  "b" '(sly-eval-buffer :wk "Eval buffer")
  "l" '(sly-load-file :wk "Load file")
  "m" '(sly-macroexpand-1 :wk "Macroexpand")
  "h" '(sly-describe-symbol :wk "Describe symbol"))

(provide 'module-lang-extra)
;;; module-lang-extra.el ends here

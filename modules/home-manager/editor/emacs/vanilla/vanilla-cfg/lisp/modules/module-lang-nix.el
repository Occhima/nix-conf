;;; module-lang-nix.el --- Nix language tooling -*- lexical-binding: t; -*-

(require 'core-evil)

;; No :mode here: `occhima/poly-nix-mode' in module-programming owns .nix files
;; and uses `nix-ts-mode' as its host mode.
(use-package nix-mode
  :commands (nix-flake nix-repl nix-repl-show nix-shell nix-build nix-unpack)
  :hook (nix-repl-mode . nix-prettify-mode)
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'nix-repl-mode 'insert)))

(use-package nix-ts-mode
  :defer t
  :hook (nix-ts-mode . eglot-ensure))

(add-hook 'nix-mode-hook #'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((nix-mode nix-ts-mode) . ("nil"))))

(with-eval-after-load 'apheleia
  (setf (alist-get 'nix-mode apheleia-mode-alist) 'nixfmt
        (alist-get 'nix-ts-mode apheleia-mode-alist) 'nixfmt))

(add-to-list 'display-buffer-alist
             '("\\*Nix-REPL"
               (display-buffer-in-side-window)
               (side . bottom)
               (window-height . 0.4)))

(occhima/local-leader (nix-mode nix-ts-mode)
  "f" '(nix-flake :wk "Nix flake")
  "r" '(nix-repl-show :wk "Nix REPL")
  "s" '(nix-shell :wk "Nix shell")
  "b" '(nix-build :wk "Nix build")
  "u" '(nix-unpack :wk "Nix unpack"))

(provide 'module-lang-nix)
;;; module-lang-nix.el ends here

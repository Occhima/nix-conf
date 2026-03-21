;;; module-vc-compile.el --- Magit and compile workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package magit
  :commands (magit-status magit-blame-addition)
  :custom
  (magit-revision-show-gravatars '(("^Author:     " . "^Commit:     "))))

(use-package compile
  :ensure nil
  :commands (compile recompile kill-compilation)
  :custom
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-scroll-output 'first-error)
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'compilation-mode 'normal)))

(occhima/leadrr
  "g" '(:ignore t :which-key "git")
  "gg" #'magit-status
  "gb" #'magit-blame-addition
  "c" '(:ignore t :which-key "compile")
  "cc" #'compile
  "cr" #'recompile
  "ck" #'kill-compilation)

(provide 'module-vc-compile)
;;; module-vc-compile.el ends here

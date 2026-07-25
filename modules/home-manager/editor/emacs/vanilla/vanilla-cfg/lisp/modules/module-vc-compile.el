;;; module-vc-compile.el --- Magit and compile workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package magit
  :commands (magit-status magit-blame-addition)
  :custom
  (magit-revision-show-gravatars '(("^Author:     " . "^Commit:     "))))

(use-package forge
  :after magit)

(use-package blamer
  :custom
  (blamer-idle-time 0.5)
  :config
  (global-blamer-mode 1))

(use-package gumshoe
  :config
  (setq gumshoe-slot-schema '(time buffer position line)
        gumshoe-auto-cancel-backtracking-p nil)
  (global-gumshoe-backtracking-mode 1))

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

(occhima/leader
  "g R" '(vc-revert :wk "Revert file")
  "g /" '(magit-dispatch :wk "Magit dispatch")
  "g ." '(magit-file-dispatch :wk "Magit file dispatch")
  "g '" '(forge-dispatch :wk "Forge dispatch")
  "g b" '(magit-branch-checkout :wk "Switch branch")
  "g g" '(magit-status :wk "Magit status")
  "g G" '(magit-status-here :wk "Magit status here")
  "g B" '(magit-blame-addition :wk "Magit blame")
  "g C" '(magit-clone :wk "Magit clone")
  "g F" '(magit-fetch :wk "Magit fetch")
  "g L" '(magit-log-buffer-file :wk "Buffer log")
  "g S" '(magit-file-stage :wk "Stage file")
  "g U" '(magit-file-unstage :wk "Unstage file")
  "c k" '(kill-compilation :wk "Kill compilation"))

(provide 'module-vc-compile)
;;; module-vc-compile.el ends here

;;; module-lang-r.el --- R/ESS workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package ess
  :mode (("\\.R\\'" . ess-r-mode)
         ("\\.r\\'" . ess-r-mode))
  :hook (ess-r-mode . eglot-ensure)
  :init
  (setq ess-eval-visibly 'nowait
        ess-ask-for-ess-directory nil)
  :config
  (setq ess-use-flymake t
        ess-style 'DEFAULT
        ess-offset-continued 'straight
        ess-nuke-trailing-whitespace-p t
        ess-history-directory (expand-file-name "ess-history/" occhima/state-directory))
  (add-hook 'inferior-ess-mode-hook
            (lambda ()
              (setq-local comint-scroll-to-bottom-on-input t
                          comint-scroll-to-bottom-on-output t
                          comint-move-point-for-output t)))
  (with-eval-after-load 'evil
    (evil-define-key 'normal ess-mode-map [C-return] #'ess-eval-line)))

(use-package ess-view-data
  :commands (ess-view-data-print))

(use-package poly-R
  :mode ("\\.[rR]md\\'" . poly-markdown+r-mode))

(use-package quarto-mode
  :mode ("\\.[qQ][mM][dD]\\'" . poly-quarto-mode))

(use-package ess-plot
  :ensure (ess-plot
           :host github
           :repo "DennieTeMolder/ess-plot"
           :files ("ess-plot.el" "*.R"))
  :after ess
  :hook (ess-r-post-run . ess-plot-on-startup-h))

(occhima/local-leader ess-r-mode
  "," '(ess-eval-region-or-function-or-paragraph-and-step :wk "Eval and step")
  "'" '(R :wk "Start R")
  "s" '(ess-switch-to-inferior-or-script-buffer :wk "Switch to REPL")
  "S" '(ess-switch-process :wk "Switch process")
  "b" '(ess-eval-buffer :wk "Eval buffer")
  "B" '(ess-eval-buffer-and-go :wk "Eval buffer and go")
  "d" '(ess-eval-region-or-line-and-step :wk "Eval region/line")
  "D" '(ess-eval-function-or-paragraph-and-step :wk "Eval function/paragraph")
  "l" '(ess-eval-line :wk "Eval line")
  "L" '(ess-eval-line-and-go :wk "Eval line and go")
  "r" '(ess-eval-region :wk "Eval region")
  "R" '(ess-eval-region-and-go :wk "Eval region and go")
  "f" '(ess-eval-function :wk "Eval function")
  "F" '(ess-eval-function-and-go :wk "Eval function and go")
  "v" '(ess-view-data-print :wk "View data"))

(provide 'module-lang-r)
;;; module-lang-r.el ends here

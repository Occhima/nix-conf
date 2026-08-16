;;; module-lang-r.el --- R/ESS workflow -*- lexical-binding: t; -*-

(use-package ess
  :mode (("\\.R\\'" . ess-r-mode)
         ("\\.r\\'" . ess-r-mode))
  :init
  (setq ess-eval-visibly 'nowait
        ess-ask-for-ess-directory nil)
  :config
  (setq ess-use-flymake t))

(use-package ess-plot
  :ensure (ess-plot
           :host github
           :repo "DennieTeMolder/ess-plot"
           :files ("ess-plot.el" "*.R"))
  :after ess
  :hook (ess-r-post-run . ess-plot-on-startup-h))

(provide 'module-lang-r)
;;; module-lang-r.el ends here

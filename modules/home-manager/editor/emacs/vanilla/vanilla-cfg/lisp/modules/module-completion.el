;;; module-completion.el --- Vertico/Corfu/Embark stack -*- lexical-binding: t; -*-

(use-package savehist
  :ensure nil
  :init
  (savehist-mode 1))

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion))
          (eglot (styles orderless))
          (eglot-capf (styles orderless)))))

(use-package marginalia
  :init
  (marginalia-mode 1))

(use-package consult)

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.15)
  (corfu-quit-no-match 'separator)
  :init
  (global-corfu-mode 1))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(provide 'module-completion)
;;; module-completion.el ends here

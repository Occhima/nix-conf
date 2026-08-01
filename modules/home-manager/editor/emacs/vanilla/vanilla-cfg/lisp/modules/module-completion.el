;;; module-completion.el --- Vertico/Corfu/Embark stack -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package savehist
  :ensure nil
  :init
  (savehist-mode 1))

(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous))
  :init
  (vertico-mode 1))

(use-package vertico-repeat
  :ensure nil
  :after vertico
  :hook (minibuffer-setup . vertico-repeat-save))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        orderless-component-separator #'orderless-escapable-split-on-space
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
  :bind (:map corfu-map
              ("C-j" . corfu-next)
              ("C-k" . corfu-previous)
              ("C-SPC" . corfu-insert-separator))
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.15)
  (corfu-quit-no-match 'separator)
  :init
  (global-corfu-mode 1)
  :config
  (general-def
    :states 'insert
    "C-SPC" #'completion-at-point))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package tempel
  :bind (("M-+" . tempel-complete)
         ("M-*" . tempel-insert))
  :custom
  (tempel-trigger-prefix "<")
  :init
  (defun occhima/tempel-setup-capf ()
    "Make Tempel available in the current completion-at-point stack."
    (add-hook 'completion-at-point-functions #'tempel-complete -90 t))
  :hook ((conf-mode prog-mode text-mode) . occhima/tempel-setup-capf))

(use-package tempel-collection
  :after tempel)

(provide 'module-completion)
;;; module-completion.el ends here


(use-package! grammarly
  :defer t
  )


(use-package! flycheck-grammarly
  :after flycheck
  :hook (org-mode markdown-mode rst-mode asciidoc-mode latex-mode LaTeX-mode)
  :config
  (flycheck-grammarly-setup)
  (setq flycheck-grammarly-check-time 0.8)
  )

(use-package! eglot-grammarly
  ;; :defer t
  :when (modulep! lsp +eglot)
  :after eglot
  ;; :ensure t
  ;;:hook (text-mode . (lambda ()
  ;;                    (require 'eglot-grammarly)
  ;;                   (call-interactively #'eglot)))
  )

;; (use-package! flymake-grammarly
;;   :after flymake
;;   :init
;;   (flycheck-grammarly-setup)
;;   :config
;;   (setq flycheck-grammarly-check-time 0.8)
;;   )

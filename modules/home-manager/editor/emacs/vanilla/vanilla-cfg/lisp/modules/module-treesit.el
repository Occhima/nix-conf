;;; module-treesit.el --- Tree-sitter defaults -*- lexical-binding: t; -*-

(use-package treesit
  :ensure nil
  :when (fboundp 'treesit-available-p)
  :custom
  (treesit-font-lock-level 4)
  :config
  (setq major-mode-remap-alist
        (append
         '((python-mode . python-ts-mode)
           (bash-mode . bash-ts-mode)
           (css-mode . css-ts-mode)
           (json-mode . json-ts-mode)
           (js-mode . js-ts-mode)
           (typescript-mode . typescript-ts-mode)
           (yaml-mode . yaml-ts-mode))
         major-mode-remap-alist)))

(provide 'module-treesit)
;;; module-treesit.el ends here

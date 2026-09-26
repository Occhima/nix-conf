;;; module-treesit.el --- Tree-sitter defaults -*- lexical-binding: t; -*-

(use-package treesit
  :ensure nil
  :when (fboundp 'treesit-available-p)
  :custom
  (treesit-font-lock-level 4)
  :config
  (dolist (remap '((python-mode . python-ts-mode)
                   (css-mode . css-ts-mode)
                   (js-mode . js-ts-mode)
                   (js-json-mode . json-ts-mode)))
    (add-to-list 'major-mode-remap-alist remap)))

(provide 'module-treesit)
;;; module-treesit.el ends here

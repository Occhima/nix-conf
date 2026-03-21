;;; module-lang-python.el --- Python workflow -*- lexical-binding: t; -*-

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :interpreter ("python3" . python-ts-mode)
  :custom
  (python-shell-interpreter "python3")
  (python-shell-interpreter-args "-i --simple-prompt --no-color-info"))

(provide 'module-lang-python)
;;; module-lang-python.el ends here

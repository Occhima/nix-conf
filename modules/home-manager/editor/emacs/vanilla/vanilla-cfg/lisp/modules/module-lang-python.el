;;; module-lang-python.el --- Python workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :interpreter ("python3" . python-ts-mode)
  :hook ((python-mode python-ts-mode) . eglot-ensure)
  :custom
  (python-shell-interpreter "python3")
  (python-shell-interpreter-args "-i --simple-prompt --no-color-info"))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("ty" "server"))))

(use-package python-pytest
  :commands (python-pytest python-pytest-dispatch))

(occhima/local-leader (python-mode python-ts-mode)
  "a" '(python-pytest :wk "Test all")
  "f" '(python-pytest-file-dwim :wk "Test file")
  "F" '(python-pytest-file :wk "Test this file")
  "t" '(python-pytest-run-def-or-class-at-point-dwim :wk "Test at point")
  "T" '(python-pytest-run-def-or-class-at-point :wk "Test def/class")
  "r" '(python-pytest-repeat :wk "Repeat test")
  "p" '(python-pytest-dispatch :wk "Pytest menu")
  "s" '(run-python :wk "REPL")
  "e" '(python-shell-send-region :wk "Send region")
  "b" '(python-shell-send-buffer :wk "Send buffer"))

(provide 'module-lang-python)
;;; module-lang-python.el ends here

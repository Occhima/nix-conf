;;; module-lang-python.el --- Python workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :interpreter ("python3" . python-ts-mode)
  :hook ((python-mode python-ts-mode) . eglot-ensure)
  :custom
  (python-shell-interpreter "python3")
  (python-shell-interpreter-args "-i"))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("ty" "server"))))

(add-to-list 'auto-mode-alist '("/uv\\.lock\\'" . toml-ts-mode))

(defun occhima/uv-activate-h ()
  "Point this buffer's PATH, `exec-path' and Python shell at its uv .venv."
  (when-let* (((derived-mode-p 'python-base-mode))
              (root (locate-dominating-file default-directory ".venv"))
              (venv (expand-file-name ".venv" root))
              (bin (expand-file-name "bin" venv))
              ((file-directory-p bin)))
    (setq-local python-shell-virtualenv-root venv
                exec-path (cons bin exec-path)
                process-environment
                (append (list (concat "VIRTUAL_ENV=" venv)
                              (concat "PATH=" bin path-separator (getenv "PATH")))
                        process-environment))))

;; Depth 90 runs after envrc, so a direnv PATH cannot hide the venv; eglot connects later.
(add-hook 'after-change-major-mode-hook #'occhima/uv-activate-h 90)

(use-package uv
  :ensure (uv :host github :repo "johannes-mueller/uv.el")
  :commands (uv uv-init uv-add uv-remove uv-sync uv-lock uv-run uv-tool-run uv-venv))

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
  "b" '(python-shell-send-buffer :wk "Send buffer")
  "u" '(uv :wk "uv"))

(provide 'module-lang-python)
;;; module-lang-python.el ends here

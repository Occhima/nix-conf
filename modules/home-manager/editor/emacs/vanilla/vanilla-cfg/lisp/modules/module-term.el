;;; module-term.el --- Terminal integration -*- lexical-binding: t; -*-

(require 'core-evil)

(defun occhima/eshell-disable-eldoc ()
  "Disable Eldoc in Eshell buffers."
  (eldoc-mode -1))

(use-package vterm
  :ensure nil
  :commands (vterm vterm-other-window)
  :custom
  (vterm-max-scrollback 10000))

(use-package eat
  :ensure nil
  :commands (eat eat-project)
  :hook (eshell-load . eat-eshell-mode)
  :custom
  (eat-enable-yank-to-terminal t)
  (eat-kill-buffer-on-exit t)
  (eat-shell-prompt-annotation-success-margin-indicator ""))

(use-package eshell
  :ensure nil
  :hook (eshell-mode . occhima/eshell-disable-eldoc)
  :custom
  (eshell-highlight-prompt nil)
  (eshell-prompt-regexp "^[^#$\n]* [$#] ")
  :config
  (defun occhima/eshell-prompt ()
    "Render a compact prompt with exit status and abbreviated directory."
    (let ((status eshell-last-command-status)
          (directory (abbreviate-file-name (eshell/pwd))))
      (format "%s %s $ "
              (propertize (if (zerop status) "➤" (format "!%d" status))
                          'face (if (zerop status) 'success 'error))
              (propertize directory 'face 'font-lock-constant-face))))
  (setq eshell-prompt-function #'occhima/eshell-prompt))

(occhima/leader
  "o t" '(vterm :wk "Terminal")
  "o T" '(vterm-other-window :wk "Terminal other window")
  "o e" '(eshell :wk "Eshell")
  "o E" '(project-eshell :wk "Eshell in project")
  "o z" '(eat :wk "Eat terminal"))

(provide 'module-term)
;;; module-term.el ends here

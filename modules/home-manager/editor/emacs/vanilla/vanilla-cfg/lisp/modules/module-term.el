;;; module-term.el --- Terminal integration -*- lexical-binding: t; -*-

(require 'core-evil)

(defun occhima/eshell-disable-eldoc ()
  "Disable Eldoc in Eshell buffers."
  (eldoc-mode -1))

(defun occhima/vterm-toggle ()
  "Toggle a vterm popup rooted at the current project."
  (interactive)
  (let* ((root (if-let* ((project (project-current))) (project-root project) default-directory))
         (name (format "*vterm-popup:%s*" (abbreviate-file-name root)))
         (window (get-buffer-window name)))
    (if window
        (delete-window window)
      (let ((default-directory root))
        (pop-to-buffer (or (get-buffer name) (save-window-excursion (vterm name))))))))

(defun occhima/vterm-here ()
  "Open vterm in the current window and directory."
  (interactive)
  (vterm t))

(defun occhima/terminal-quiet-ui ()
  "Drop editing affordances inside terminal buffers."
  (setq-local mode-line-format nil
              show-trailing-whitespace nil
              confirm-kill-processes nil
              hscroll-margin 0))

(add-to-list 'display-buffer-alist
             '("\\*vterm-popup:"
               (display-buffer-in-side-window)
               (side . bottom)
               (slot . -4)
               (window-height . 0.25)))

(add-to-list 'display-buffer-alist
             '("\\*eat\\*"
               (display-buffer-in-side-window)
               (side . bottom)
               (slot . -4)
               (window-height . 0.25)))

(use-package vterm
  :ensure nil
  :commands (vterm vterm-other-window)
  :hook (vterm-mode . occhima/terminal-quiet-ui)
  :bind (:map vterm-mode-map ("C-q" . vterm-send-next-key))
  :custom
  (vterm-kill-buffer-on-exit t)
  (vterm-max-scrollback 10000))

(use-package eat
  :ensure nil
  :commands (eat eat-project)
  :hook ((eshell-load . eat-eshell-mode)
         (eat-mode . occhima/terminal-quiet-ui))
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
  "o t" '(occhima/vterm-toggle :wk "Toggle vterm popup")
  "o T" '(occhima/vterm-here :wk "Open vterm here")
  "o e" '(eshell :wk "Eshell")
  "o E" '(project-eshell :wk "Eshell in project")
  "o z" '(eat :wk "Eat terminal")
  "o Z" '(eat-project :wk "Eat in project"))

(provide 'module-term)
;;; module-term.el ends here

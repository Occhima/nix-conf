;;; early-init.el --- Early startup tuning -*- lexical-binding: t; -*-

(require 'subr-x)

(defun occhima/load-env-file (file)
  "Load environment variables from FILE with lines in KEY=VALUE format."
  (when (file-readable-p file)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line (string-trim (buffer-substring-no-properties (line-beginning-position)
                                                                 (line-end-position)))))
          (when (and (not (string-empty-p line))
                     (not (string-prefix-p "#" line))
                     (string-match "\\`\\([^=[:space:]]+\\)=\\(.*\\)\\'" line))
            (setenv (match-string 1 line) (match-string 2 line))))
        (forward-line 1)))))

(dolist (env-file
         (list
          (expand-file-name ".local/env" user-emacs-directory)
          (expand-file-name "~/.config/doom/.local/env")))
  (occhima/load-env-file env-file))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      package-enable-at-startup nil
      frame-inhibit-implied-resize t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(setq-default cursor-in-non-selected-windows nil)

(provide 'early-init)
;;; early-init.el ends here

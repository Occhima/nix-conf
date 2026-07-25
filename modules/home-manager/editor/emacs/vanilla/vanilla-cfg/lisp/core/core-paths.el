;;; core-paths.el --- XDG state and cache locations -*- lexical-binding: t; -*-

(defun occhima/xdg-directory (environment fallback child)
  "Return CHILD below ENVIRONMENT, or below FALLBACK when it is unset."
  (file-name-as-directory
   (expand-file-name child (or (getenv environment)
                               (expand-file-name fallback)))))

(defconst occhima/cache-directory
  (occhima/xdg-directory "XDG_CACHE_HOME" "~/.cache" "emacs"))
(defconst occhima/data-directory
  (occhima/xdg-directory "XDG_DATA_HOME" "~/.local/share" "emacs"))
(defconst occhima/state-directory
  (occhima/xdg-directory "XDG_STATE_HOME" "~/.local/state" "emacs"))

(dolist (directory (list occhima/cache-directory
                         occhima/data-directory
                         occhima/state-directory))
  (make-directory directory t))

(provide 'core-paths)
;;; core-paths.el ends here

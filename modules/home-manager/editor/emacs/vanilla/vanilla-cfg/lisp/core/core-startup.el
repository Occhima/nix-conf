;;; core-startup.el --- Baseline startup and identity -*- lexical-binding: t; -*-

(setq user-full-name "Marco Occhialini"
      user-mail-address "marcoocchialini@usp.br"
      delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files"
      command-line-default-directory "~/"
      ring-bell-function #'ignore)

(setq backup-directory-alist `(("." . ,(expand-file-name "backup/" user-emacs-directory)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t))
      create-lockfiles nil)

(make-directory (expand-file-name "backup/" user-emacs-directory) t)
(make-directory (expand-file-name "auto-save/" user-emacs-directory) t)

(provide 'core-startup)
;;; core-startup.el ends here

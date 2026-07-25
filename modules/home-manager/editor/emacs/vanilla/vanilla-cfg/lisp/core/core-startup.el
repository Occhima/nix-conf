;;; core-startup.el --- Baseline startup and identity -*- lexical-binding: t; -*-

(require 'core-paths)

(setq user-full-name "Marco Occhialini"
      user-mail-address "marcoocchialini@usp.br"
      delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files"
      command-line-default-directory "~/"
      ring-bell-function #'ignore)

(let ((backup-directory (expand-file-name "backup/" occhima/cache-directory))
      (auto-save-directory (expand-file-name "auto-save/" occhima/cache-directory)))
  (make-directory backup-directory t)
  (make-directory auto-save-directory t)
  (setq backup-directory-alist `(("." . ,backup-directory))
        auto-save-file-name-transforms `((".*" ,auto-save-directory t))))

(setq bookmark-default-file
      (expand-file-name "bookmarks" occhima/state-directory)
      custom-file
      (expand-file-name "custom.el" occhima/state-directory)
      project-list-file
      (expand-file-name "projects" occhima/state-directory)
      recentf-save-file
      (expand-file-name "recentf" occhima/state-directory)
      savehist-file
      (expand-file-name "history" occhima/state-directory)
      save-place-file
      (expand-file-name "places" occhima/state-directory)
      transient-history-file
      (expand-file-name "transient/history.el" occhima/state-directory)
      transient-levels-file
      (expand-file-name "transient/levels.el" occhima/state-directory)
      transient-values-file
      (expand-file-name "transient/values.el" occhima/state-directory)
      url-history-file
      (expand-file-name "url/history" occhima/state-directory)
      create-lockfiles nil)

(make-directory (file-name-directory transient-history-file) t)
(make-directory (file-name-directory url-history-file) t)

(provide 'core-startup)
;;; core-startup.el ends here

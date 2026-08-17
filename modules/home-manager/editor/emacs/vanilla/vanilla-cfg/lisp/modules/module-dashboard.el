;;; module-dashboard.el --- Startup dashboard -*- lexical-binding: t; -*-

(require 'core-ui)

(defconst occhima/dashboard-banner
  (expand-file-name "banners/blackhole-polykai.svg" user-emacs-directory))

(defconst occhima/flake-directory (expand-file-name "~/.config/flake"))

(defun occhima/browse-flake ()
  "Browse the flake that builds this configuration."
  (interactive)
  (dired occhima/flake-directory))

(defun occhima/update-packages ()
  "Fetch and merge every package Elpaca has queued."
  (interactive)
  (elpaca-merge-all t t))

(defun occhima/dashboard-quiet-ui ()
  "Drop the global editing affordances inside the dashboard buffer."
  (setq-local show-trailing-whitespace nil)
  (display-line-numbers-mode -1))

(defun occhima/dashboard-on-client-frame (&optional frame)
  "Show the dashboard when a client FRAME opens on an empty buffer."
  (with-selected-frame (or frame (selected-frame))
    (when (member (buffer-name) '("*scratch*" "*GNU Emacs*"))
      (dashboard-open))))

(defun occhima/dashboard-action (command)
  "Return a dashboard button action running COMMAND interactively."
  (lambda (&rest _) (call-interactively command)))

(defun occhima/dashboard-shortcut (icon label command keys)
  "Build a dashboard navigator row for COMMAND, shown as ICON, LABEL and KEYS."
  (list icon
        (format " %-18s" label)
        (format "%s (%s)" label keys)
        (occhima/dashboard-action command)
        nil
        ""
        keys))

(defun occhima/dashboard-navigator ()
  "Return the navigator rows describing this configuration."
  `(((,(nerd-icons-mdicon "nf-md-snowflake" :height 1.1 :v-adjust 0.0)
      "Flake"
      "Browse the flake sources"
      ,(occhima/dashboard-action #'occhima/browse-flake)
      nil "" " |")
     (,(nerd-icons-codicon "nf-cod-package" :height 1.1 :v-adjust 0.0)
      "Update"
      "Pull and rebuild every Elpaca package"
      ,(occhima/dashboard-action #'occhima/update-packages)
      warning "" " |")
     (,(nerd-icons-codicon "nf-cod-server_process" :height 1.1 :v-adjust 0.0)
      "Daemon"
      "Restart the Emacs daemon"
      ,(occhima/dashboard-action #'occhima/restart-server)
      error "" ""))

    (("" "\n" "" nil nil "" ""))

    (,(occhima/dashboard-shortcut
       (nerd-icons-faicon "nf-fa-search" :height 0.9 :v-adjust -0.1)
       "Find file" #'find-file "SPC ."))
    (,(occhima/dashboard-shortcut
       (nerd-icons-octicon "nf-oct-file_directory" :height 1.0 :v-adjust -0.1)
       "Switch project" #'project-switch-project "SPC p p"))
    (,(occhima/dashboard-shortcut
       (nerd-icons-octicon "nf-oct-three_bars" :height 1.1 :v-adjust -0.1)
       "File explorer" #'dirvish "SPC o /"))
    (,(occhima/dashboard-shortcut
       (nerd-icons-codicon "nf-cod-search" :height 0.9 :v-adjust -0.1)
       "Search project" #'consult-ripgrep "SPC /"))
    (,(occhima/dashboard-shortcut
       (nerd-icons-codicon "nf-cod-calendar" :height 0.9 :v-adjust -0.1)
       "Org agenda" #'org-agenda "SPC n a"))
    (,(occhima/dashboard-shortcut
       (nerd-icons-codicon "nf-cod-settings" :height 0.9 :v-adjust -0.1)
       "Edit config" #'occhima/find-file-in-config "SPC f e"))))

(use-package dashboard
  :ensure (dashboard :wait t)
  :demand t
  :hook (dashboard-mode . occhima/dashboard-quiet-ui)
  :custom
  (dashboard-banner-logo-title "[Ο Κ Κ Ι Μ Α ❄ Ε Δ Ι Τ Ο Ρ]")
  (dashboard-startup-banner occhima/dashboard-banner)
  (dashboard-image-banner-max-height 260)
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-newline
                               dashboard-insert-banner-title
                               dashboard-insert-newline
                               dashboard-insert-navigator
                               dashboard-insert-newline
                               dashboard-insert-init-info
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-footer))
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-projects-backend 'project-el)
  (dashboard-remove-missing-entry t)
  (dashboard-path-style 'truncate-middle)
  (dashboard-path-max-length 60)
  (dashboard-agenda-release-buffers t)
  (dashboard-items '((recents . 5)
                     (projects . 5)
                     (bookmarks . 5)
                     (agenda . 5)))
  (dashboard-footer-messages
   '("Reproducible by construction: the flake remembers what you forget."
     "Any text editor can save your files, only Emacs can save your soul."
     "A configuration you cannot rebuild from scratch is a configuration you rent."
     "The best abstraction is the one you never had to write."))
  :config
  (setq dashboard-footer-icon
        (nerd-icons-mdicon "nf-md-snowflake"
                           :height 1.1
                           :v-adjust -0.05
                           :face 'font-lock-keyword-face)
        dashboard-navigator-buttons (occhima/dashboard-navigator)
        initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  (dashboard-setup-startup-hook)
  (add-hook 'server-after-make-frame-hook #'occhima/dashboard-on-client-frame)
  :custom-face
  (dashboard-heading ((t (:inherit font-lock-keyword-face :weight bold))))
  (dashboard-navigator ((t (:inherit font-lock-keyword-face))))
  (dashboard-banner-logo-title ((t (:inherit font-lock-doc-face)))))

(occhima/leader
  "o d" '(dashboard-open :wk "Dashboard"))

(provide 'module-dashboard)
;;; module-dashboard.el ends here

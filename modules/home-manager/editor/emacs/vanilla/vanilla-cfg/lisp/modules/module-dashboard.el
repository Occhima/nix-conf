;;; module-dashboard.el --- Startup dashboard -*- lexical-binding: t; -*-

;; Welcome-screen style after https://github.com/gs-101/.emacs.d
;; (dashboard package: white Emacs logo, centered title, init info,
;; projects list, bracket navigator buttons, "Vi Vi Vi" footer).
;; Logo asset gs-101-emacs.png is gs-101's edit of the GNU Emacs icon.

(require 'core-ui)

(defconst occhima/dashboard-banner
  (expand-file-name "banners/gs-101-emacs.png" user-emacs-directory))

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

    (,(nerd-icons-codicon "nf-cod-note" :height 1.1 :v-adjust 0.0)
     "Open Scratch Buffer"
     "Switch to the scratch buffer"
     ,(lambda (&rest _) (switch-to-buffer (get-scratch-buffer-create)))
     nil "" " |")
    (,(nerd-icons-codicon "nf-cod-calendar" :height 1.1 :v-adjust 0.0)
     "Open Org Agenda"
     "Switch to the agenda buffer"
     ,(occhima/dashboard-action #'org-agenda)
     nil "" " |")
    (,(nerd-icons-codicon "nf-cod-settings" :height 1.1 :v-adjust 0.0)
     "Open Config"
     "Open the Nix flake configuration"
     #'occhima/browse-flake
     nil "" "")))

(use-package dashboard
  :ensure (dashboard :wait t)
  :demand t
  :hook (dashboard-mode . occhima/dashboard-quiet-ui)
  :custom
  (dashboard-banner-logo-title "The Extensible Computing Environment")
  (dashboard-startup-banner occhima/dashboard-banner)
  (dashboard-image-banner-max-height 260)
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-banner-title
                               dashboard-insert-init-info
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-navigator
                               dashboard-insert-newline
                               dashboard-insert-footer))
  (dashboard-modify-heading-icons '((agenda . "nf-oct-calendar")
                                    (projects . "nf-oct-project")
                                    (recents . "nf-oct-clock")))
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-projects-backend 'project-el)
  (dashboard-remove-missing-entry t)
  (dashboard-path-style 'truncate-middle)
  (dashboard-path-max-length 60)
  (dashboard-agenda-release-buffers t)
  (dashboard-items '((agenda . 5)
                     (projects . 5)
                     (recents . 5)))
  (dashboard-footer-messages
   '("Vi Vi Vi, the editor of the beast."
     "Welcome-screen style after https://github.com/gs-101/.emacs.d"
     "Reproducible by construction: the flake remembers what you forget."
     "Any text editor can save your files, only Emacs can save your soul."))
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

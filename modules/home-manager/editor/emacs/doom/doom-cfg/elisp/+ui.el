(setq
 frame-title-format '"\n"          ; newline pushes resize info off the titlebar
 undo-limit 80000000
 evil-want-fine-undo t
 auto-save-default t
 truncate-string-ellipsis "…"
 display-line-numbers-type 'relative
 which-key-idle-delay 0.3
 which-key-idle-secondary-delay 0
 +workspaces-on-switch-project-behavior t
 evil-vsplit-window-right t
 evil-split-window-below t
 show-trailing-whitespace t
 doom-theme 'doom-polykai
 doom-font (font-spec :family "Iosevka Comfy" :size 15 :weight 'SemiBold)
 doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font Mono" :size 15)
 ;; JuliaMono is not installed; nerd-icons glyphs live in Symbols Nerd Font Mono.
 doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
 doom-emoji-font (font-spec :family "Noto Color Emoji")
 doom-fallback-buffer-name "*dashboard*")

;; Welcome screen after https://github.com/gs-101/.emacs.d, same as vanilla
;; module-dashboard.el, with Doom's own splash SVG.

(defun +occhima/dashboard-on-client-frame (&optional frame)
  "Show the dashboard when a client FRAME opens on an empty buffer."
  (with-selected-frame (or frame (selected-frame))
    (when (member (buffer-name) '("*scratch*" "*doom*"))
      (dashboard-open))))

(defun +occhima/dashboard-action (command)
  "Return a dashboard button action running COMMAND interactively."
  (lambda (&rest _) (call-interactively command)))

(defun +occhima/browse-flake ()
  "Browse the flake that builds this configuration."
  (interactive)
  (dired "~/.config/flake"))

(defun +occhima/refresh-doom ()
  "Run doom sync and restart the daemon."
  (interactive)
  (when (yes-or-no-p "Run refresh-doom (restarts the daemon)? ")
    (save-some-buffers nil t)
    (async-shell-command "refresh-doom")))

(use-package! dashboard
  :demand t
  :hook (dashboard-mode . (lambda ()
                            (setq-local show-trailing-whitespace nil)
                            (display-line-numbers-mode -1)))
  :custom
  (dashboard-banner-logo-title "The Extensible Computing Environment")
  (dashboard-startup-banner (expand-file-name "misc/splash/emacs.svg" doom-user-dir))
  (dashboard-image-banner-max-height 260)
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  (dashboard-icon-type 'nerd-icons)
  ;; Default is `display-graphic-p': the daemon renders before any GUI frame exists.
  (dashboard-display-icons-p t)
  (dashboard-startupify-list '(dashboard-insert-banner
                               dashboard-insert-banner-title
                               dashboard-insert-init-info
                               dashboard-insert-items
                               dashboard-insert-newline
                               dashboard-insert-navigator
                               dashboard-insert-newline
                               dashboard-insert-footer))
  (dashboard-modify-heading-icons '((projects . "nf-oct-project")
                                    (recents . "nf-oct-clock")))
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-projects-backend 'projectile)
  (dashboard-remove-missing-entry t)
  (dashboard-path-style 'truncate-middle)
  (dashboard-path-max-length 60)
  (dashboard-items '((projects . 5)
                     (recents . 5)))
  (dashboard-footer-messages
   '("Vi Vi Vi, the editor of the beast."
     "Welcome-screen style after https://github.com/gs-101/.emacs.d"
     "Reproducible by construction: the flake remembers what you forget."
     "Any text editor can save your files, only Emacs can save your soul."))
  :config
  (setq dashboard-footer-icon
        (nerd-icons-mdicon "nf-md-snowflake" :height 1.1 :v-adjust -0.05
                           :face 'font-lock-keyword-face)
        dashboard-navigator-buttons
        `(((,(nerd-icons-mdicon "nf-md-snowflake" :height 1.1 :v-adjust 0.0)
            "Flake" "Browse the flake sources"
            ,(+occhima/dashboard-action #'+occhima/browse-flake)
            nil "" " |")
           (,(nerd-icons-codicon "nf-cod-package" :height 1.1 :v-adjust 0.0)
            "Sync" "Run doom sync and restart the daemon"
            ,(+occhima/dashboard-action #'+occhima/refresh-doom)
            warning "" ""))
          (("" "\n" "" nil nil "" ""))
          ((,(nerd-icons-codicon "nf-cod-note" :height 1.1 :v-adjust 0.0)
            "Open Scratch Buffer" "Switch to the scratch buffer"
            ,(lambda (&rest _) (switch-to-buffer (get-scratch-buffer-create)))
            nil "" "")))
        initial-buffer-choice (lambda () (get-buffer-create dashboard-buffer-name)))
  (dashboard-setup-startup-hook)
  (add-hook 'server-after-make-frame-hook #'+occhima/dashboard-on-client-frame))

(custom-set-faces!
  '(dashboard-heading :inherit font-lock-keyword-face :weight bold)
  '(dashboard-navigator :inherit font-lock-keyword-face)
  '(dashboard-banner-logo-title :inherit font-lock-doc-face)
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

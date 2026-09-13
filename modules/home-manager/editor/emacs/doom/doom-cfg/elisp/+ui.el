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
 doom-symbol-font (font-spec :family "JuliaMono")
 doom-fallback-buffer-name "*dashboard*"
 ;; Resolved against doom-private-dir: with nix-doom-emacs that is the
 ;; built doomDir in the Nix store, not ~/.config/doom.
 fancy-splash-image (expand-file-name "misc/splash/emacs.svg" doom-private-dir))

;; Dashboard restyled after https://github.com/gs-101/.emacs.d
;; (white Emacs logo, centered title, init info, project list,
;; bracket footer buttons). The gs-101-emacs.png logo is gs-101's
;; edit of the GNU Emacs icon from the Emacs source repository.

(defun +occhima/dashboard-widget-banner ()
  "Doom's banner widget, with the splash logo capped at 260px tall.

The stock widget inserts the logo at its natural size (550px here),
which overflows smaller frames and skews Doom's line-count-based
vertical centering.  260px matches the vanilla Emacs config
(`dashboard-image-banner-max-height')."
  (let ((create-image (symbol-function #'create-image)))
    (cl-letf (((symbol-function #'create-image)
               (lambda (file &rest args)
                 (apply create-image file nil nil :max-height 260 args))))
      (+dashboard-widget-banner))))

(defun +occhima/dashboard-widget-title ()
  "Centered configuration title below the banner."
  (+dashboard-insert
   (propertize "The Extensible Computing Environment"
               'face '+dashboard-menu-title)))

(defun +occhima/dashboard-widget-projects ()
  "Project list with icons, after gs-101's dashboard."
  (require 'project)
  ;; Doom tracks projects through projectile; project.el's cache is usually
  ;; empty at startup, so ask projectile first.
  (let* ((projects (seq-filter #'file-directory-p
                               (delete-dups
                                (append (bound-and-true-p projectile-known-projects)
                                        (project-known-project-roots)))))
         (roots (seq-take projects 5)))
    (when roots
      (let* ((rows (mapcar
                    (lambda (root)
                      (concat (nerd-icons-octicon "nf-oct-file_directory"
                                                  :face 'nerd-icons-blue
                                                  :v-adjust -0.1)
                              " "
                              (abbreviate-file-name root)))
                    roots))
             (heading (concat (nerd-icons-octicon "nf-oct-project"
                                                  :face 'nerd-icons-lblue
                                                  :v-adjust -0.1)
                              " "
                              (propertize (format "[Projects (%d)]" (length roots))
                                          'face '+dashboard-menu-title)))
             ;; gs-101's block is flush-left: center it as a unit, rows aligned.
             (block (cons heading rows)))
        (+dashboard-insert (string-join block "\n"))))))

(defun +occhima/dashboard-widget-footer ()
  "Bracket-button footer, after gs-101's dashboard."
  (+dashboard-insert
   (with-temp-buffer
     (dolist (button (list (list (nerd-icons-codicon "nf-cod-note")
                                 "Open Scratch Buffer"
                                 "Switch to the scratch buffer"
                                 (lambda (_) (switch-to-buffer (get-scratch-buffer-create))))
                           (list (nerd-icons-codicon "nf-cod-calendar")
                                 "Open Org Agenda"
                                 "Switch to the agenda buffer"
                                 (lambda (_) (org-agenda)))
                           (list (nerd-icons-codicon "nf-cod-settings")
                                 "Open Config"
                                 "Open the Nix flake configuration"
                                 (lambda (_) (find-file "~/.config/flake")))))
       (pcase-let ((`(,icon ,label ,help ,fn) button))
         (insert "[")
         (insert-text-button (concat icon " " label)
                             'action fn 'help-echo help 'follow-link t)
         (insert "]  ")))
     (buffer-string))
   (propertize "\nVi Vi Vi, the editor of the beast"
               'face 'font-lock-comment-face)))

(setq +dashboard-functions
      '(+occhima/dashboard-widget-banner
        +occhima/dashboard-widget-title
        +dashboard-widget-loaded
        +occhima/dashboard-widget-projects
        +dashboard-widget-spacer
        +occhima/dashboard-widget-footer))

;; Doom's own daemon-only fix for doomemacs/core#2219 (dashboard loses
;; center alignment after a persp/workspace switch) doesn't cover regular
;; GUI startup. `+workspaces-on-switch-project-behavior' means every
;; project switch triggers a persp activation, so apply the same fix
;; unconditionally.
(add-hook 'persp-activated-functions #'+dashboard-reload-maybe-h)

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))

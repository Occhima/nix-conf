(setq
 frame-title-format '"\n" ; use a new-line to make sure rezising info is on the next line
 undo-limit 80000000      ; Raise undo-limit to 80Mb
 evil-want-fine-undo t ; By default while in insert all changes are one big blob. Be more granular
 auto-save-default t   ; Nobody likes to loose work, I certainly don't
 truncate-string-ellipsis "…" ; Unicode ellispis are nicer than "...", and also save /precious/ space
 display-line-numbers-type 'relative
 which-key-idle-delay 0.3               ; Show key binding help quicker
 +workspaces-on-switch-project-behavior t
 evil-vsplit-window-right t
 evil-split-window-below t
 show-trailing-whitespace t
 which-key-idle-secondary-delay 0
 doom-theme 'doom-polykai
 doom-font (font-spec :family "Iosevka Comfy" :size 15 :weight 'SemiBold)
 doom-variable-pitch-font (font-spec :family "Iosevka Nerd Font Mono" :size 15)
 doom-symbol-font (font-spec :family "JuliaMono")
 doom-fallback-buffer-name "*dashboard*"
 fancy-splash-image "~/.config/doom/misc/splash/emacs.svg"
 )

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic)
  )


(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

(after! doom-themes
  (setq
   doom-themes-enable-bold t
   doom-themes-enable-italic t))

(after! centaur-tabs
  (centaur-tabs-mode)
  (centaur-tabs-group-by-projectile-project)
  (setq centaur-tabs-set-bar 'over
        centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons 'buffer
        centaur-tabs-height 24
        centaur-tabs-set-modified-marker t
        centaur-tabs-style "slant"
        centaur-tabs-modified-marker "•"))

;; emacs-dashboard setup

;; (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))
;;       doom-fallback-buffer-name "*dashboard*")
;; (require 'all-the-icons)
;; (setq dashboard-banner-logo-title "In Stallman we trust")
;; (setq dashboard-startup-banner "~/.config/doom/misc/splash/nix.webp")
;; (setq dashboard-icon-type 'all-the-icons) ;; use `all-the-icons' package
;; (setq dashboard-set-heading-icons t)
;; (setq dashboard-set-file-icons t)
;; (setq dashboard-startupify-list '(dashboard-insert-banner
;;                                   dashboard-insert-newline
;;                                   dashboard-insert-banner-title
;;                                   dashboard-insert-newline
;;                                   dashboard-insert-navigator
;;                                   dashboard-insert-newline
;;                                   dashboard-insert-init-info
;;                                   dashboard-insert-items
;;                                   dashboard-insert-newline
;;                                   dashboard-insert-footer))
;; (setq dashboard-center-content t
;;       dashboard-vertically-center-content t
;;       )
;; (setq dashboard-footer-messages '("Here to do customizing, or actual work?"
;;                                   "M-x insert-inspiring-message"
;;                                   "My software never has bugs. It just develops random features."
;;                                   "Dad, what are clouds made of? Linux servers, mostly."
;;                                   "There is no place like ~"
;;                                   "~ sweet ~"
;;                                   "sudo chown -R us ./allyourbase"
;;                                   "I’ll tell you a DNS joke but it could take 24 hours for everyone to get it."
;;                                   "I'd tell you a UDP joke, but you might not get it."
;;                                   "I'll tell you a TCP joke. Do you want to hear it?"))

;; ;; Format: "(icon title help action face prefix suffix)"
;; (setq dashboard-navigator-buttons
;;       `(;; line1
;;         ;; line 2
;;         ((,(all-the-icons-faicon "linkedin" :height 1.1 :v-adjust 0.0)
;;           "Linkedin"
;;           ""
;;           (lambda (&rest _) (browse-url "homepage")))
;;          ("⚑" nil "Show flags" (lambda (&rest _) (message "flag")) error))))

;; (setq dashboard-footer-icon
;;       (all-the-icons-faicon "list-alt"
;;                             :height 1.0
;;                             :v-adjust -0.15
;;                             :face 'font-lock-keyword-face))
;; (dashboard-setup-startup-hook)

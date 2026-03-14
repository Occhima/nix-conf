;; Telega is broken, search issues to find what's happening
(after! telega
  (setq telega-use-docker t))

;; mu4e
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")

(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        mu4e-index-cleanup nil
        mu4e-index-lazy-check t
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-update-interval 60 ; seconds between each mail r
        +mu4e-gmail-accounts '(("Gmail" . "/gmail"))
        )

  ;; (set-email-account! "Usp"
  ;;                     '(
  ;;                       (mu4e-sent-folder       . "//sent items")
  ;;                       (mu4e-drafts-folder     . "//drafts")
  ;;                       (mu4e-trash-folder      . "/gmail/trash")
  ;;                       (mu4e-refile-folder     . "/gmail/Inbox")
  ;;                       (smtpmail-smtp-user     . "marcoocchialini2@gmail.com")
  ;;                       (user-mail-address     . "marcoocchialini2@gmail.com")
  ;;                       (mu4e-compose-signature . "---\nAtte,\nMarco Occhialini")
  ;;                       )
  ;;                     t)

  (set-email-account! "Gmail"
                      '(
                        (mu4e-sent-folder       . "/gmail/sent items")
                        (mu4e-drafts-folder     . "/gmail/drafts")
                        (mu4e-trash-folder      . "/gmail/trash")
                        (mu4e-refile-folder     . "/gmail/Inbox")
                        (smtpmail-smtp-user     . "marcoocchialini2@gmail.com")
                        (user-mail-address     . "marcoocchialini2@gmail.com")
                        (mu4e-compose-signature . "---\nAtte,\nMarco Occhialini")
                        )
                      t)

  (set-email-account! "Hotmail"
                      '(
                        (mu4e-sent-folder       . "/hotmail/sent items")
                        (mu4e-drafts-folder     . "/hotmail/Drafts")
                        (mu4e-trash-folder      . "/hotmail/trash")
                        (mu4e-refile-folder     . "/hotmail/Inbox")
                        (smtpmail-smtp-user     . "marcoocchialini@hotmail.com")
                        (user-mail-address     . "marcoocchialini@hotmail.com")
                        (mu4e-compose-signature . "---\nAtte,\nMarco Occhialini")
                        )
                      t)
  )



(after! org-gcal
  (setq org-gcal-client-id (+pass-get-secret "google/agenda/client_id")
        org-gcal-client-secret (+pass-get-secret "google/agenda/client_secret")
        org-gcal-fetch-file-alist '(("marcoocchialini2@gmail.com" .  "~/Dropbox/projects/org/gcal/personal.org")
                                    )
        plstore-cache-passphrase-for-symmetric-encryption t)
  (org-gcal-reload-client-id-secret)
  )

(after! elfeed
  (setq rmh-elfeed-org-files '("~/.config/doom/misc/elfeed.org")
        elfeed-log-level 'error
        )
  ;; (require 'elfeed-tube)
  ;; (elfeed-tube-setup)

  ;; (add-hook! 'elfeed-search-mode-hook 'elfeed-update)
  )

(after! mastodon
  (setq mastodon-instance-url "https://mastodon.social"
        mastodon-active-user "metax")
  )

(after! calibredb
  (setq calibredb-root-dir "~/Dropbox/projects/library/books/kindle"
        calibredb-db-dir "~/Dropbox/projects/library/books/kindle/metadata.db"
        calibredb-format-all-the-icons t)

  )


(after! empv
  (empv-toggle-video)
  (setq empv-invidious-instance "https://invidious.fdn.fr/api/v1"))


(after! chatgpt-shell
  (setq chatgpt-shell-openai-key (+pass-get-secret "openai/api_key"))

  )

(after! gptel
  ;; We can add more backend inside here.,
  (setq gptel-api-key  (+pass-get-secret "openai/api_key")))



(after! emacs-everywhere
  (setq emacs-everywhere-frame-name-format "emacs-anywhere")
  (remove-hook 'emacs-everywhere-init-hooks #'hide-mode-line-mode)
  (defadvice! center-emacs-everywhere-in-origin-window (frame window-info)
    :override #'emacs-everywhere-set-frame-position
    (cl-destructuring-bind (x y width height)
        (emacs-everywhere-window-geometry window-info)
      (set-frame-position frame
                          (+ x (/ width 2) (- (/ width 2)))
                          (+ y (/ height 2))))))
;; (after! elfeed-tube
;;   :after elfeed
;;   :init
;;   (map! :map elfeed-show-mode-map
;;         :localleader
;;         :n "F" #'elfeed-tube-fetch
;;         :map elfeed-search-mode-map
;;         :localleader
;;         :n "F" #'elfeed-tube-fetch)
;;   :config
;;   ;; (setq elfeed-tube-auto-save-p nil) ; default value
;;   ;; (setq elfeed-tube-auto-fetch-p t)  ; default value
;;   (elfeed-tube-setup))

(after! khoj
  (setq khoj-api-key (auth-source-pass-get 'secret "khoj/api_key")
        khoj-index-directories '("~/Dropbox/projects/org/roam"))
  )


;; (after! calc
;;   (require 'casual)
;;   (map! :map calc-mode-map "C-o" #'casual-main-menu
;;         :desc " Open calculator transient"
;;         )
;;   )

(after! circe
  (set-irc-server! "irc.libera.chat"
    `(:tls t
      :port 6697
      :nick "metax"
      :sasl-username ,(+pass-get-user "irc/libera.chat")
      :sasl-password (lambda (&rest _) (+pass-get-secret "irc/libera.chat"))
      :channels ("#emacs")))
  )


(after! smudge
  (setq smudge-oauth2-client-id (+pass-get-secret "spotify/account/client_id")
        smudge-oauth2-client-secret (+pass-get-secret "spotify/account/client_secret")
        smudge-player-use-transient-map t
        )
  )

;;; module-apps.el --- Mail, feeds, books, maps, and calendar -*- lexical-binding: t; -*-

(require 'core-evil)

(defun occhima/pass-secret (entry)
  "Return the secret stored at password-store ENTRY."
  (require 'auth-source-pass)
  (auth-source-pass-get 'secret entry))

(use-package mu4e
  :ensure nil
  :commands mu4e
  :custom
  (mu4e-maildir "~/maildir")
  (mu4e-index-cleanup nil)
  (mu4e-index-lazy-check t)
  (mu4e-update-interval 60)
  :config
  (setq sendmail-program (executable-find "msmtp")
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-context-policy 'pick-first
        mu4e-compose-context-policy 'ask
        mu4e-contexts
        (list
         (make-mu4e-context
          :name "Gmail"
          :match-func
          (lambda (message)
            (when message
              (string-prefix-p
               "/gmail"
               (mu4e-message-field message :maildir))))
          :vars
          '((user-mail-address . "marcoocchialini2@gmail.com")
            (smtpmail-smtp-user . "marcoocchialini2@gmail.com")
            (mu4e-sent-folder . "/gmail/sent")
            (mu4e-drafts-folder . "/gmail/drafts")
            (mu4e-trash-folder . "/gmail/trash")
            (mu4e-refile-folder . "/gmail/archive")
            (mu4e-compose-signature . "---\nAtte,\nMarco Occhialini"))))))

(use-package org-gcal
  :after org
  :commands (org-gcal-fetch org-gcal-sync)
  :custom
  (org-gcal-fetch-file-alist
   '(("marcoocchialini2@gmail.com"
      . "~/Dropbox/projects/org/gcal/personal.org")))
  (plstore-cache-passphrase-for-symmetric-encryption t)
  :config
  (setq org-gcal-client-id
        (occhima/pass-secret "google/agenda/client_id")
        org-gcal-client-secret
        (occhima/pass-secret "google/agenda/client_secret"))
  (org-gcal-reload-client-id-secret))

(use-package elfeed
  :commands elfeed
  :custom
  (elfeed-log-level 'error))

(use-package elfeed-org
  :after elfeed
  :custom
  (rmh-elfeed-org-files
   (list (expand-file-name "misc/elfeed.org" user-emacs-directory)))
  :config
  (elfeed-org))

(use-package nov
  :mode ("\\.epub\\'" . nov-mode)
  :hook ((nov-mode . mixed-pitch-mode)
         (nov-mode . visual-line-mode)
         (nov-mode . visual-fill-column-mode))
  :custom
  (nov-text-width t)
  (nov-variable-pitch nil))

(use-package calibredb
  :ensure (calibredb
           :host github
           :repo "chenyanming/calibredb.el")
  :commands calibredb
  :custom
  (calibredb-root-dir "~/Dropbox/projects/library/books/kindle")
  (calibredb-db-dir "~/Dropbox/projects/library/books/kindle/metadata.db")
  (calibredb-format-nerd-icons t)
  :bind (:map calibredb-show-mode-map
              ("v" . calibredb-view)))

(use-package biome
  :commands biome
  :custom
  (biome-query-coords
   '(("Helsinki, Finland" 60.16952 24.93545)
     ("Berlin, Germany" 52.52437 13.41053)
     ("Dubai, UAE" 25.0657 55.17128)
     ("São Paulo, Brazil" -23.5475 -46.63611))))

(use-package osm
  :ensure (osm :host github :repo "minad/osm")
  :commands osm
  :custom
  (osm-server 'default)
  (osm-copyright t))

(use-package consult-gh
  :ensure (consult-gh :host github :repo "armindarvish/consult-gh" :files ("*.el"))
  :commands (consult-gh-search-repos consult-gh-dashboard)
  :custom
  (consult-gh-show-preview t)
  (consult-gh-preview-key "C-o")
  (consult-gh-default-clone-directory "~/Dropbox/projects")
  :config
  (require 'consult-gh-embark)
  (consult-gh-embark-mode 1)
  (require 'consult-gh-forge)
  (consult-gh-forge-mode 1)
  (consult-gh-enable-default-keybindings))

(use-package consult-mu
  :ensure (consult-mu :host github :repo "armindarvish/consult-mu")
  :defer t)

(use-package consult-omni
  :ensure (consult-omni :host github
                        :repo "armindarvish/consult-omni"
                        :files (:defaults "sources/*.el"))
  :commands (consult-omni-multi consult-omni-multi-static)
  :custom
  (consult-omni-show-preview t)
  (consult-omni-preview-key "C-o")
  (consult-omni-default-count 5)
  :config
  (require 'consult-omni-sources)
  (require 'consult-omni-embark)
  (setq consult-omni-sources-modules-to-load
        '(consult-omni-wikipedia
          consult-omni-duckduckgo
          consult-omni-gh
          consult-omni-elfeed
          consult-omni-mu4e
          consult-omni-org-agenda
          consult-omni-ripgrep
          consult-omni-grep
          consult-omni-fd
          consult-omni-man
          consult-omni-stackoverflow))
  (consult-omni-sources-load-modules))

(use-package visual-fill-column
  :commands visual-fill-column-mode)

(use-package circe
  :commands circe
  :config
  (require 'auth-source-pass)
  (setq circe-network-options
        `(("Libera Chat"
           :host "irc.libera.chat"
           :tls t
           :port 6697
           :nick "metax"
           :sasl-username ,(auth-source-pass-get "user" "irc/libera.chat")
           :sasl-password (lambda (&rest _) (occhima/pass-secret "irc/libera.chat"))
           :channels ("#emacs")))))

(defun occhima/irc ()
  "Connect to Libera Chat."
  (interactive)
  (circe "Libera Chat"))

(use-package telega
  :ensure nil
  :commands telega)

(use-package ement
  :commands (ement-connect ement-list-rooms))

(use-package calfw
  :commands cfw:open-calendar-buffer)

(use-package calfw-org
  :commands cfw:open-org-calendar)

(occhima/leader
  "o m" '(mu4e :wk "Mail")
  "o i" '(occhima/irc :wk "IRC")
  "o g" '(telega :wk "Telegram")
  "o M" '(ement-connect :wk "Matrix")
  "o c" '(cfw:open-org-calendar :wk "Calendar"))

(provide 'module-apps)
;;; module-apps.el ends here

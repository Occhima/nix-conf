;;; +apps.el -*- lexical-binding: t; -*-

(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-index-cleanup nil
        mu4e-index-lazy-check t
        mu4e-update-interval 60
        +mu4e-gmail-accounts '(("Gmail" . "/gmail")))

  (set-email-account! "Gmail"
                      '((mu4e-sent-folder . "/gmail/sent items")
                        (mu4e-drafts-folder . "/gmail/drafts")
                        (mu4e-trash-folder . "/gmail/trash")
                        (mu4e-refile-folder . "/gmail/Inbox")
                        (smtpmail-smtp-user . "marcoocchialini2@gmail.com")
                        (user-mail-address . "marcoocchialini2@gmail.com")
                        (mu4e-compose-signature . "---\nAtte,\nMarco Occhialini"))
                      t)

  (set-email-account! "Hotmail"
                      '((mu4e-sent-folder . "/hotmail/sent items")
                        (mu4e-drafts-folder . "/hotmail/Drafts")
                        (mu4e-trash-folder . "/hotmail/trash")
                        (mu4e-refile-folder . "/hotmail/Inbox")
                        (smtpmail-smtp-user . "marcoocchialini@hotmail.com")
                        (user-mail-address . "marcoocchialini@hotmail.com")
                        (mu4e-compose-signature . "---\nAtte,\nMarco Occhialini"))
                      t))

(after! org-gcal
  (setq org-gcal-client-id (+pass-get-secret "google/agenda/client_id")
        org-gcal-client-secret (+pass-get-secret "google/agenda/client_secret")
        org-gcal-fetch-file-alist
        '(("marcoocchialini2@gmail.com" . "~/Dropbox/projects/org/gcal/personal.org"))
        plstore-cache-passphrase-for-symmetric-encryption t)
  (org-gcal-reload-client-id-secret))

(after! elfeed
  (setq rmh-elfeed-org-files '("~/.config/doom/misc/elfeed.org")
        elfeed-log-level 'error))

(after! circe
  (set-irc-server! "irc.libera.chat"
    `(:tls t
      :port 6697
      :nick "metax"
      :sasl-username ,(+pass-get-user "irc/libera.chat")
      :sasl-password (lambda (&rest _) (+pass-get-secret "irc/libera.chat"))
      :channels ("#emacs"))))

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :hook ((nov-mode . mixed-pitch-mode)
         (nov-mode . visual-line-mode)
         (nov-mode . visual-fill-column-mode))
  :custom
  (nov-text-width t)
  (nov-variable-pitch nil))

(use-package! calibredb
  :commands calibredb
  :custom
  (calibredb-root-dir "~/Dropbox/projects/library/books/kindle")
  (calibredb-db-dir "~/Dropbox/projects/library/books/kindle/metadata.db")
  (calibredb-format-all-the-icons t)
  :config
  (map! :map calibredb-show-mode-map
        "v" #'calibredb-view))

(use-package! biome
  :commands biome
  :custom
  (biome-query-coords
   '(("Helsinki, Finland" 60.16952 24.93545)
     ("Berlin, Germany" 52.52437 13.41053)
     ("Dubai, UAE" 25.0657 55.17128)
     ("São Paulo, Brazil" -23.5475 -46.63611))))

(use-package! osm
  :commands osm
  :custom
  (osm-server 'default)
  (osm-copyright t))

(use-package! consult-gh
  :commands (consult-gh-search-repos consult-gh-dashboard)
  :custom
  (consult-gh-show-preview t)
  (consult-gh-preview-key "C-o")
  (consult-gh-default-clone-directory "~/Dropbox/projects")
  :init
  (map! :leader
        :prefix "s"
        :desc "Search GitHub repos" "g" #'consult-gh-search-repos)
  :config
  (require 'consult-gh-embark)
  (consult-gh-enable-default-keybindings))

(use-package! consult-gh-embark
  :after consult-gh
  :config
  (consult-gh-embark-mode +1))

(use-package! consult-gh-forge
  :after consult-gh
  :config
  (consult-gh-forge-mode +1))


(use-package! consult-omni
  :commands (consult-omni-multi consult-omni-multi-static)
  :custom
  (consult-omni-show-preview t)
  (consult-omni-preview-key "C-o")
  (consult-omni-default-count 5)
  :init
  (map! :leader
        :prefix "s"
        :desc "Omni search" "o" #'consult-omni-multi)
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

(use-package! eat
  :commands (eat eat-project eat-other-window eat-project-other-window)
  :init
  (add-hook! 'eat-mode-hook #'doom-mark-buffer-as-real-h (setq-local mode-line-format nil))
  (add-hook 'eshell-load-hook #'eat-eshell-mode)
  (add-hook 'eshell-load-hook #'eat-eshell-visual-command-mode)
  (map! :leader
        :desc "Eat terminal" "o e" #'eat
        :desc "Eat in project" "o E" #'eat-project
        :desc "Eat other window" "o w" #'eat-other-window
        :desc "Eat project other window" "o W" #'eat-project-other-window)
  :custom
  (eat-kill-buffer-on-exit t)
  (eat-enable-yank-to-terminal t)
  (eat-term-scrollback-size (* 1024 1024))
  (eat-shell-prompt-annotation-success-margin-indicator "")
  (eat-shell-prompt-annotation-running-margin-indicator "•")
  (eat-shell-prompt-annotation-failure-margin-indicator "✗")
  ;; called from the shell via `_eat_msg NAME ARGS...' (see zsh.nix)
  (eat-message-handler-alist
   '(("open" . find-file-other-window)
     ("dired" . dired-other-window)
     ("magit" . magit-status)))
  :config
  ;; let Doom's insert-state leader (M-SPC) reach Emacs instead of the shell
  (add-to-list 'eat-semi-char-non-bound-keys [?\e ?\s])
  (eat-update-semi-char-mode-map)
  (set-popup-rule! "^\\*eat" :size 0.25 :vslot -4 :select t :quit nil :ttl 0)
  (map! :map eat-mode-map
        :n "[[" #'eat-previous-shell-prompt
        :n "]]" #'eat-next-shell-prompt
        :localleader
        :desc "Semi-char mode" "s" #'eat-semi-char-mode
        :desc "Char mode (M-RET exits)" "c" #'eat-char-mode
        :desc "Line mode" "l" #'eat-line-mode
        :desc "Emacs mode" "e" #'eat-emacs-mode
        :desc "Narrow to prompt" "n" #'eat-narrow-to-shell-prompt
        :desc "Send password" "p" #'eat-send-password
        :desc "Reset terminal" "r" #'eat-reset
        :desc "Kill process" "k" #'eat-kill-process))

(use-package! exc
  :commands (exc-open exc-create exc-find-file-csv)
  :config
  (require 'exc-csv)
  (require 'exc-org)
  (require 'exc-markdown))

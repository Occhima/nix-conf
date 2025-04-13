
;; Variables
(defvar *my-search-engines*
  (list
   (make-instance 'search-engine :name "Google" :shortcut "g"
                                 :control-url "https://google.com/search?q=~a")
   (make-instance 'search-engine :name "Google Scholar" :shortcut "gs"
                                 :control-url "https://scholar.google.com/scholar?q=~a")
   (make-instance 'search-engine :name "GitHub" :shortcut "git"
                                 :control-url "https://github.com/search?q=~a")
   (make-instance 'search-engine :name "Reddit" :shortcut "r"
                                 :control-url "https://old.reddit.com/search?q=~a")
   (make-instance 'search-engine :name "YouTube" :shortcut "yt"
                                 :control-url "https://yewtu.be/search?q=~a")
   (make-instance 'search-engine :name "Arxiv" :shortcut "ax"
                                 :control-url "https://arxiv.org/search?query=~a&searchtype=all&source=header")
   (make-instance 'search-engine :name "Arch Linux AUR" :shortcut "arch"
                                 :control-url "https://aur.archlinux.org/packages?O=0&K=~a")
   (make-instance 'search-engine :name "Flathub" :shortcut "fl"
                                 :control-url "https://flathub.org/apps/search?q=~a")))


;; Config
(define-configuration (browser)
    (
     (restore-session-on-startup-p nil)
     (external-editor-program (if (member :flatpak *features*)
                                  "flatpak-spawn --host /usr/local/bin/emacsclient -c"
                                  "/usr/local/bin/emacsclient -r"))
     (search-engines (append  %slot-default% *my-search-engines*))
     )
  )

(define-configuration nyxt/mode/password:password-mode
    (
     (nyxt/mode/password:password-interface
      (make-instance 'password:password-store-interface :executable (if (member :flatpak *features*)
                                                                        "flatpak-spawn --host /usr/bin/pass"
                                                                        "/usr/bin/pass")))
     )
  )

(define-configuration (input-buffer)
    ((default-modes (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration (prompt-buffer)
    ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))


(define-configuration nyxt/mode/proxy:proxy-mode
    ((nyxt/mode/proxy:proxy (make-instance 'proxy
                                           :url (quri:uri "http://127.0.0.1:8080")
                                           :allowlist '("localhost" "localhost:8080")
                                           :proxied-downloads-p t))))

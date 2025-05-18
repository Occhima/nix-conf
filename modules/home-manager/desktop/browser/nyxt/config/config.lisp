(in-package #:nyxt-user)

;;; this file was created and edited in NYXT with ace-mode

(defvar *buffer-modes*
  '(vi-normal-mode)
  "Modes to enable in buffer by default")

;; don't hint images
(define-configuration nyxt/mode/hint:hint-mode
    ((nyxt/mode/hint:hints-alphabet "DSJKHLFAGNMXCWEIO")
     (nyxt/mode/hint:hints-selector "a, button, input, textarea, details, select")))

;; add custom user agent and block utm
(define-configuration nyxt/mode/reduce-tracking:reduce-tracking-mode
    ((nyxt/mode/reduce-tracking:query-tracking-parameters
      (append '("utm_source" "utm_medium" "utm_campaign" "utm_term" "utm_content")
              %slot-value%))
     (preferred-user-agent
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36")))

(defmethod files:resolve ((profile nyxt:nyxt-profile) (file nyxt/mode/bookmark:bookmarks-file))
  "Reroute the bookmarks to the config directory."
  #p"~/.config/nyxt/bookmarks.lisp")

(define-nyxt-user-system-and-load nyxt-user/style-config
  :components ("style"
               "status"))

;; extensions
(define-nyxt-user-system-and-load nyxt-user/extra-config
  :components (
               "commands"
               "repl"
               "search-engines"
               ))

;; simple web-buffer customization
(define-configuration buffer
    (;; basic mode setup for web-buffer
     (default-modes `(,@*buffer-modes*
                      ,@%slot-value%))))

;; we wan't to be in insert mode in the prompt buffer, don't show source if theres only one
(define-configuration (prompt-buffer)
    ((default-modes `(vi-insert-mode
                      ,@%slot-value%))
     (hide-single-source-header-p t)))

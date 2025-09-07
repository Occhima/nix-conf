;; NOTE: This config was stolen from https://github.com/shaunsingh/nix-darwin-dotfiles
(in-package #:nyxt-user)

(defvar *buffer-modes*
  '(vi-normal-mode)
  "Modes to enable in buffer by default")


(defvar *my-search-engines*
  (list
   (make-instance 'search-engine :name "Google" :shortcut "g"
                                 :control-url "https://google.com/search?q=~a")
   (make-instance 'search-engine :name "MyNixos" :shortcut "mn"
                                 :control-url "https://mynixos.com/search?q=~a")
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

(define-configuration nyxt/mode/hint:hint-mode
    ((nyxt/mode/hint:hints-alphabet "DSJKHLFAGNMXCWEIO")
     (nyxt/mode/hint:hints-selector "a, button, input, textarea, details, select")))

;; (define-configuration nyxt/mode/reduce-tracking:reduce-tracking-mode
;;     ((nyxt/mode/reduce-tracking:query-tracking-parameters
;;       (append '("utm_source" "utm_medium" "utm_campaign" "utm_term" "utm_content")
;;               %slot-value%))
;;      (preferred-user-agent
;;       "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36")))

(defmethod files:resolve ((profile nyxt:nyxt-profile) (file nyxt/mode/bookmark:bookmarks-file))
  #p"~/.config/nyxt/bookmarks.lisp")

(define-configuration (browser)
    (
     ;; (restore-session-on-startup-p nil)
     (external-editor-program (if (member :flatpak *features*)
                                  "flatpak-spawn --host emacsclient -c"
                                  "emacsclient -r"))
     (search-engines (append  %slot-default% *my-search-engines*))
     )
  )

(define-configuration nyxt/mode/password:password-mode
    (
     (nyxt/mode/password:password-interface
      (make-instance 'password:password-store-interface :executable (if (member :flatpak *features*)
                                                                        "flatpak-spawn --host pass"
                                                                        "pass")))
     )
  )


(define-configuration buffer
    (;; basic mode setup for web-buffer
     (default-modes `(,@*buffer-modes*
                      ,@%slot-value%))))

(define-configuration (prompt-buffer)
    (
     (default-modes `(vi-insert-mode
                      ,@%slot-value%))
     ;; (hide-single-source-header-p t)
     )
  )


;; Load theme configuration
;; This is so dumb I hate this
(when (probe-file #p"~/.config/flake-themes/nyxt/theme.lisp")
  (load #p"~/.config/flake-themes/nyxt/theme.lisp"))


;; Custom functions
;; Stolen, not mine
;; (defun my-open-files (filename)
;;   "Open music and videos with mpv, open directories with emacsclient."
;;   (let ((args)
;;         (extension (pathname-type filename)))
;;     (cond
;;       ((uiop:directory-pathname-p filename)
;;        (log:info "Opening ~a with emacsclient." filename)
;;        (setf args (list "emacsclient" filename)))

;;       ((member extension '("flv" "mkv" "mp4") :test #'string-equal)
;;        (setf args (list "mpv" filename))))

;;     (handler-case (if args
;;                       (uiop:launch-program args)
;;                       (next/file-manager-mode:open-file-function filename))
;;       (error (c) (log:error "Error opening ~a: ~a" filename c)))))
;; (setf nyxt/mode/file-manager:*open-file-function* #'my-open-files)

(in-package #:nyxt-user)

(dolist (generated '(#p"~/.config/flake-themes/nyxt/theme.lisp"
                     #p"~/.config/flake-nyxt/slynk.lisp"))
  (when (probe-file generated)
    (load generated)))

(defparameter *components*
  '("robustness"
    "electron-sockets"
    "styles"
    "window-splits"
    "search-engines"
    "start-page"
    "browser"
    "status-buffer"
    "message-buffer"
    "prompt-buffer"
    "web-buffer"
    "mirrors"
    "passwords"
    "emacs")
  "Files under lisp/, in load order.

Loaded by hand rather than through `define-nyxt-user-system' because the 4.0.0
binary release ships an empty ASDF source location (`Source location: #P\"\"' at
startup), which makes defining a nyxt-user subsystem signal an error.")

(dolist (component *components*)
  (let ((file (merge-pathnames (format nil "lisp/~a.lisp" component) *load-truename*)))
    (handler-case (load file)
      (error (condition)
        ;; One unloadable component must not take the rest of the configuration
        ;; with it: stock Nyxt 4 crashes on startup without the `format-status'
        ;; guard in status-buffer.lisp, so aborting the load loop turns any
        ;; error here into a browser that will not start.
        (format *error-output* "~&Nyxt config: skipped ~a: ~a~%" component condition)))))

(in-package #:nyxt-user)

(dolist (generated '(#p"~/.config/flake-themes/nyxt/theme.lisp"
                     #p"~/.config/flake-nyxt/slynk.lisp"))
  (when (probe-file generated)
    (load generated)))

(defparameter *components*
  '("robustness" ; first: installs the debugger hook that keeps later load errors survivable
    "electron-sockets" ; prunes stale renderer sockets before any Electron view starts
    "styles" ; shared fonts/glyphs/hairlines used by the buffers below
    "window-splits" ; %tile, reused by prompt-buffer's floating palette
    "search-engines" ; *extra-search-engines*, consumed by browser
    "favicons" ; favicon cache, consumed by start-page
    "start-page" ; the start-page command referenced by browser
    "browser" ; depends on search-engines and start-page
    "status-buffer" ; styled with styles
    "message-buffer" ; styled with styles
    "prompt-buffer" ; floats over window-splits' tiling
    "mirrors" ; defines mirror-mode for web-buffer's default-modes
    "web-buffer" ; styles + mirrors
    "view-source"
    "search-buffer"
    "passwords"
    "emacs")
  "Files under lisp/, in load order.

Loaded by hand rather than through `define-nyxt-user-system' because the 4.0.0
binary release ships an empty ASDF source location (`Source location: #P\"\"' at
startup), which makes defining a nyxt-user subsystem signal an error.

keybindings.lisp and vi-input-fields.lisp are kept in the tree for reference
but deliberately not listed: they are no longer in use.")

(dolist (component *components*)
  (let ((file (merge-pathnames (format nil "lisp/~a.lisp" component) *load-truename*)))
    (handler-case (load file)
      (error (condition)
        ;; One unloadable component must not take the rest of the configuration
        ;; with it: stock Nyxt 4 crashes on startup without the `format-status'
        ;; guard in status-buffer.lisp, so aborting the load loop turns any
        ;; error here into a browser that will not start.
        ;; `*error-output*' is lost when Nyxt is launched from the GUI, so the
        ;; message also lands in a log file next to robustness.lisp's
        ;; thread-errors.log.
        (let ((message (format nil "Nyxt config: skipped ~a: ~a~%" component condition)))
          (format *error-output* "~a" message)
          (ignore-errors
            (ensure-directories-exist #p"~/.local/share/nyxt/")
            (alexandria:write-string-into-file
             message #p"~/.local/share/nyxt/config-errors.log"
             :if-exists :append)))))))

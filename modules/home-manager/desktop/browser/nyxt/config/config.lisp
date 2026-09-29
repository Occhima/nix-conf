(in-package #:nyxt-user)

(dolist (generated '(#p"~/.config/flake-themes/nyxt/theme.lisp"
                     #p"~/.config/flake-nyxt/slynk.lisp"
                     #p"~/.config/flake-nyxt/paths.lisp"))
  (when (probe-file generated)
    (load generated)))

(defparameter *components*
  '("robustness" ; first: installs the debugger hook that keeps later load errors survivable
    "electron-sockets" ; prunes stale renderer sockets before any Electron view starts
    "styles" ; shared fonts/glyphs/hairlines used by the buffers below
    "window-splits" ; %tile, reused by prompt-buffer's floating palette
    "search-engines" ; *extra-search-engines*, consumed by browser
    "favicons" ; favicon cache, consumed by start-page
    "session" ; autosave, and the restore offer start-page renders
    "start-page" ; the start-page command referenced by browser
    "browser" ; depends on search-engines and start-page
    "status-buffer" ; styled with styles
    "message-buffer" ; styled with styles
    "prompt-buffer" ; floats over window-splits' tiling
    "mirrors" ; defines mirror-mode for web-buffer's default-modes
    "site-modes" ; site-modes-mode for web-buffer, reuses status-buffer's mode helpers
    "userscripts" ; userscript-mode for web-buffer's default-modes
    "web-buffer" ; styles + mirrors + site-modes + userscripts
    "view-source"
    "search-buffer"
    "passwords"
    "emacs"
    "reader"
    "links" ; clean-url and org-link, used by hints
    "pdf" ; wraps hint following, so after nothing that redefines it
    "hints" ; emacs + links + pdf
    "navigation"
    ;; "vi"
    "which-key"
    "keys")
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

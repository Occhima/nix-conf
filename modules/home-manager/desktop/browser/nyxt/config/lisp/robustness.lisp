(in-package #:nyxt-user)

(defvar *default-debugger-hook* sb-ext:*invoke-debugger-hook*
  "The hook `--disable-debugger' installed, kept for the main thread.

Captured with `defvar' so that reloading this file leaves the original in
place rather than capturing the replacement and delegating to itself.")

(defun %timestamp ()
  "Local time as YYYY-MM-DD HH:MM:SS, to order entries across a freeze."
  (multiple-value-bind (s m h day month year) (get-decoded-time)
    (format nil "~d-~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d" year month day h m s)))

(defun %log-line (text)
  "Write TEXT, timestamped, to *error-output* and to the thread-errors log.

*error-output* is lost for a GUI launch;
~/.local/share/nyxt/thread-errors.log survives."
  (ignore-errors
   (let ((line (format nil "~&~a Nyxt: ~a~%" (%timestamp) text)))
     (format *error-output* "~a" line)
     (finish-output *error-output*)
     ;; ponytail: append-only file, rotate by hand when it grows.
     (with-open-file (out (merge-pathnames "nyxt/thread-errors.log"
                                           (uiop:xdg-data-home))
                          :direction :output
                          :if-does-not-exist :create
                          :if-exists :append)
       (write-string line out)))))

(defun %log-thread-condition (condition)
  "Write CONDITION to the log without a backtrace.

The backtrace of a dying thread is what makes the log unreadable when
several go at once, and the condition alone says which one to look at."
  (%log-line (format nil "unhandled ~a in ~a: ~a"
                     (type-of condition)
                     (sb-thread:thread-name sb-thread:*current-thread*)
                     condition)))

(defun %survive-thread-condition (condition hook)
  "End the thread that signalled CONDITION rather than the whole session.

Nyxt runs with the debugger disabled, so a condition no handler took quits
the process, and Nyxt runs every load, key and renderer callback in a
thread of its own.  A browser that drops one callback is worth having; a browser
that disappears mid-session is not.  The main thread is left to quit as it
did, nothing being recoverable there and a swallowed condition leaving it
wedged rather than gone.

A warning carrying a `muffle-warning' restart is answered with it and
execution continues, nothing a mere warning describes being worth a
session.  `nkeymaps' raises one of those, `override-existing-binding',
whenever a keymap rebinds a key that was already bound, and reaching the
debugger with it is what hangs Nyxt when bindings are added from a
configuration file -- atlas-engineer/nyxt#3389."
  (%log-thread-condition condition)
  (when (typep condition 'warning)
    (alexandria:when-let ((restart (find-restart 'muffle-warning condition)))
      (invoke-restart restart)))
  (if (sb-thread:main-thread-p)
      (when *default-debugger-hook*
        (funcall *default-debugger-hook* condition hook))
      (sb-thread:abort-thread)))

(setf sb-ext:*invoke-debugger-hook* #'%survive-thread-condition)

(%log-line "--- started ---")

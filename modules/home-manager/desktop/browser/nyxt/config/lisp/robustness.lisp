(in-package #:nyxt-user)

(defvar *default-debugger-hook* sb-ext:*invoke-debugger-hook*
  "The hook `--disable-debugger' installed, kept for the main thread.

Captured with `defvar' so that reloading this file leaves the original in
place rather than capturing the replacement and delegating to itself.")

(defun %log-thread-condition (condition)
  "Write CONDITION to the log without a backtrace.

The backtrace of a dying thread is what makes the log unreadable when
several go at once, and the condition alone says which one to look at.
Goes to *error-output* -- lost for a GUI launch -- and to
~/.local/share/nyxt/thread-errors.log, which survives."
  (ignore-errors
   (let ((line (format nil "~&Nyxt: unhandled ~a in ~a: ~a~%"
                       (type-of condition)
                       (sb-thread:thread-name sb-thread:*current-thread*)
                       condition)))
     (format *error-output* "~a" line)
     (finish-output *error-output*)
     ;; ponytail: append-only file, rotate by hand when it grows.
     (with-open-file (out (merge-pathnames "nyxt/thread-errors.log"
                                           (uiop:xdg-data-home))
                          :direction :output
                          :if-does-not-exist :create
                          :if-exists :append)
       (write-string line out)))))

(defun %survive-thread-condition (condition hook)
  "End the thread that signalled CONDITION rather than the whole session.

Nyxt runs with the debugger disabled, so a condition no handler took quits
the process, and cl-electron gives every window event, view callback and
JavaScript reply a thread of its own reading a socket that can be closed
under it.  A browser that drops one callback is worth having; a browser
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

(defvar *decode-json-from-string* (fdefinition 'cl-json:decode-json-from-string)
  "cl-json's reader as it was before the guard below replaced it.")

(defun %decode-json-guarded (source &rest arguments)
  "End the socket thread on EOF; returning NIL makes cl-electron's read loop spin."
  (if (or (stringp source) (sb-thread:main-thread-p))
      (apply *decode-json-from-string* source arguments)
      (sb-thread:abort-thread)))

(setf (fdefinition 'cl-json:decode-json-from-string) #'%decode-json-guarded)

(defvar *javascript-timeout* 10
  "Seconds a synchronous JavaScript call may take before it returns NIL.")

;; Same specializers as cl-electron's method, so this `defmethod' replaces it.
(defmethod electron:execute-javascript-synchronous ((web-contents electron:web-contents) code
                                                    &key (user-gesture "false"))
  "Stock cl-electron waits forever; a page closed mid-call froze Nyxt."
  (let ((done (bt:make-semaphore))
        (result nil))
    (multiple-value-bind (thread-id socket-thread)
        (electron:execute-javascript-with-promise-callback
         web-contents code
         (lambda (web-contents value)
           (declare (ignore web-contents))
           (setf result value)
           (bt:signal-semaphore done))
         :user-gesture user-gesture)
      (declare (ignore thread-id))
      (unwind-protect
           (if (bt:wait-on-semaphore done :timeout *javascript-timeout*)
               result
               (progn (%log-thread-condition
                       (make-condition 'simple-warning
                                       :format-control "JavaScript call timed out after ~as"
                                       :format-arguments (list *javascript-timeout*)))
                      nil))
        (electron::destroy-thread* socket-thread)))))

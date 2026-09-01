(in-package #:nyxt-user)

(defvar *default-debugger-hook* sb-ext:*invoke-debugger-hook*
  "The hook `--disable-debugger' installed, kept for the main thread.

Captured with `defvar' so that reloading this file leaves the original in
place rather than capturing the replacement and delegating to itself.")

(defun %log-thread-condition (condition)
  "Write CONDITION to the log without a backtrace.

The backtrace of a dying thread is what makes the log unreadable when
several go at once, and the condition alone says which one to look at."
  (ignore-errors
   (format *error-output* "~&Nyxt: unhandled ~a in ~a: ~a~%"
           (type-of condition)
           (sb-thread:thread-name sb-thread:*current-thread*)
           condition)
   (finish-output *error-output*)))

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
  "Decode SOURCE, reading a closed socket as no message rather than an error.

cl-electron hands whatever it read off its socket straight to the decoder,
and an end of file -- which is what a view or a window going away in the
middle of a message looks like -- arrives here as NIL and signals a type
error in a thread of cl-electron's own.  That is the frame every one of
the crashed sessions ended in."
  (when (stringp source)
    (apply *decode-json-from-string* source arguments)))

(setf (fdefinition 'cl-json:decode-json-from-string) #'%decode-json-guarded)

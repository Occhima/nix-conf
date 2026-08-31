(in-package #:nyxt-user)

(defun %socket-bound-p (path)
  "Whether some process currently holds a Unix socket at PATH."
  (with-open-file (stream #p"/proc/net/unix" :if-does-not-exist nil)
    (when stream
      (loop for line = (read-line stream nil)
            while line
            thereis (search path line)))))

(defun %prune-stale-electron-sockets ()
  "Delete cl-electron socket files that nothing is listening on.

cl-electron numbers its per-object sockets from zero on every run and sanitizes
only electron.socket, so a file left behind by a killed instance collides with
the new run's identifiers.  The `IDnnn.socket already in use' warning means the
listener that should have owned that identifier was dropped, taking with it
whichever window or view event it was carrying."
  (let ((directory (uiop:xdg-runtime-dir "cl-electron/")))
    (when (uiop:directory-exists-p directory)
      (dolist (socket (uiop:directory-files directory "*.socket"))
        (unless (%socket-bound-p (uiop:native-namestring socket))
          (uiop:delete-file-if-exists socket))))))

(%prune-stale-electron-sockets)

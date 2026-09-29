(in-package #:nyxt-user)

(defvar *session-file*
  (merge-pathnames "nyxt/session.lisp" (uiop:xdg-data-home))
  "Open buffer URLs of the running session, rewritten while Nyxt runs.")

(defvar *previous-session-file*
  (merge-pathnames "nyxt/session-previous.lisp" (uiop:xdg-data-home))
  "The session the last run left behind, rotated here at startup.

Rotating before autosave starts is what keeps a crashed session restorable:
otherwise the first save of the fresh run would overwrite it with the start
page alone.")

(defvar *session-interval* 60
  "Seconds between session autosaves.")

(defvar *session-thread* nil)
(defvar *saved-session* :unsaved
  "URLs last written, so an unchanged session costs no disk write.")
(defvar *session-restored-p* nil)

(defun %session-urls ()
  "URL strings of the open web buffers, oldest first, internal pages excepted."
  (loop for buffer in (reverse (buffer-list))
        for url = (ignore-errors (url buffer))
        when (and (web-buffer-p buffer)
                  url
                  (not (url-empty-p url))
                  (not (internal-url-p url)))
          collect (quri:render-uri url)))

(defun %write-session (urls)
  (let ((temporary (make-pathname :type "tmp" :defaults *session-file*)))
    (ensure-directories-exist *session-file*)
    (with-open-file (out temporary :direction :output :if-exists :supersede)
      (with-standard-io-syntax
        (prin1 urls out)))
    (rename-file temporary *session-file*)))

(defun save-session ()
  "Write the open buffer URLs to `*session-file*' when they changed."
  (ignore-errors
   (let ((urls (%session-urls)))
     (unless (equal urls *saved-session*)
       (%write-session urls)
       (setf *saved-session* urls)))))

(defun previous-session-urls ()
  (ignore-errors (uiop:read-file-form *previous-session-file*)))

(defun %start-session-autosave (&rest arguments)
  (declare (ignore arguments))
  (unless (and *session-thread* (bt:thread-alive-p *session-thread*))
    (when (probe-file *session-file*)
      (rename-file *session-file* *previous-session-file*))
    (setf *session-thread*
          (bt:make-thread (lambda ()
                            (loop (sleep *session-interval*)
                                  (save-session)))
                          :name "Nyxt session autosave"))))

(define-configuration browser
  ((after-startup-hook (hooks:add-hook %slot-value% '%start-session-autosave))
   (before-exit-hook (hooks:add-hook %slot-value% 'save-session))))

(define-command-global restore-session ()
  "Reopen the buffers of the previous run, once."
  (let ((urls (previous-session-urls)))
    (cond (*session-restored-p*
           (echo-warning "The previous session is already restored."))
          ((null urls)
           (echo-warning "No previous session to restore."))
          (t
           (setf *session-restored-p* t)
           ;; ponytail: every buffer loads at once; lazy loading needs a
           ;; load-on-focus hook if sessions grow to dozens of buffers.
           (dolist (url urls)
             (make-buffer :url (quri:uri url)))
           (echo "Restored ~a buffer~:p." (length urls))))))

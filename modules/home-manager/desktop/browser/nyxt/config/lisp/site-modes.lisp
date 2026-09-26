(in-package #:nyxt-user)

(defvar *site-modes-file*
  (merge-pathnames "nyxt/site-modes.lisp" (uiop:xdg-data-home)))

(defvar *site-modes*
  (ignore-errors (uiop:read-file-form *site-modes-file*))
  "List of (HOST ENABLED DISABLED), mode names re-applied on every load of HOST.")

(defun %save-site-modes ()
  (ensure-directories-exist *site-modes-file*)
  (with-open-file (out *site-modes-file* :direction :output :if-exists :supersede)
    (with-standard-io-syntax
      (prin1 *site-modes* out))))

(define-command remember-site-modes (&optional (buffer (current-buffer)))
  "Re-apply the modes toggled by hand in BUFFER on every future visit to its host."
  (alexandria:when-let ((host (quri:uri-host (url buffer))))
    (let* ((baseline (%baseline-mode-names buffer))
           (active (%active-mode-names buffer))
           (enabled (set-difference active baseline))
           (disabled (remove 'site-modes-mode (set-difference baseline active))))
      (setf *site-modes*
            (cons (list host enabled disabled)
                  (remove host *site-modes* :key #'first :test #'string-equal)))
      (%save-site-modes)
      (echo "~a: +~{~(~a~)~^ ~} -~{~(~a~)~^ ~}" host enabled disabled))))

(define-command forget-site-modes (&optional (buffer (current-buffer)))
  "Stop re-applying remembered modes on BUFFER's host."
  (alexandria:when-let ((host (quri:uri-host (url buffer))))
    (setf *site-modes* (remove host *site-modes* :key #'first :test #'string-equal))
    (%save-site-modes)
    (echo "Forgot modes for ~a" host)))

(define-mode site-modes-mode ()
  "Apply the modes remembered with `remember-site-modes'."
  ((visible-in-status-p nil)))

(defmethod on-signal-load-started ((mode site-modes-mode) url)
  (alexandria:when-let ((entry (assoc (quri:uri-host url) *site-modes* :test #'equalp)))
    (destructuring-bind (enabled disabled) (rest entry)
      (when enabled (enable-modes* enabled (buffer mode)))
      (when disabled (disable-modes* disabled (buffer mode)))))
  url)

(in-package #:nyxt-user)

(defvar *site-modes-file*
  (merge-pathnames "nyxt/site-modes.lisp" (uiop:xdg-data-home)))

(defvar *site-modes*
  (ignore-errors (uiop:read-file-form *site-modes-file*))
  "List of (HOST ENABLED DISABLED ZOOM MUTED) re-applied on every load of HOST.

ENABLED and DISABLED are mode names; ZOOM is a ratio, or NIL for the default.
Entries saved before ZOOM and MUTED existed have only the first three.")

(defvar *site-zoomed-buffers* (make-hash-table :test 'eq :weakness :key)
  "Buffers whose zoom or sound came from a remembered site, to undo on leaving it.")

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
           (disabled (remove 'site-modes-mode (set-difference baseline active)))
           (ratio (ffi-buffer-zoom-ratio buffer))
           (zoom (unless (< (abs (- ratio (zoom-ratio-default buffer))) 0.01)
                   (float ratio 1.0)))
           (muted (not (ffi-buffer-sound-enabled-p buffer))))
      (setf *site-modes*
            (cons (list host enabled disabled zoom muted)
                  (remove host *site-modes* :key #'first :test #'string-equal)))
      (%save-site-modes)
      (echo "~a: +~{~(~a~)~^ ~} -~{~(~a~)~^ ~}~@[ zoom ~,2f~]~:[~; muted~]"
            host enabled disabled zoom muted))))

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
    (destructuring-bind (enabled disabled &optional zoom muted) (rest entry)
      (declare (ignore zoom muted))
      (when enabled (enable-modes* enabled (buffer mode)))
      (when disabled (disable-modes* disabled (buffer mode)))))
  url)

;; Zoom and sound wait for load-finished: `document-mode' re-applies the
;; buffer's zoom there, and on Electron the URL at load-started can still be
;; the previous page's for a link click.
(defmethod on-signal-load-finished ((mode site-modes-mode) url title)
  (declare (ignore title))
  (let* ((buffer (buffer mode))
         (entry (assoc (quri:uri-host url) *site-modes* :test #'equalp))
         (zoom (fourth entry))
         (muted (fifth entry)))
    (cond ((or zoom muted)
           (when zoom
             (setf (ffi-buffer-zoom-ratio buffer) (float zoom 1.0)))
           (setf (ffi-buffer-sound-enabled-p buffer) (not muted)
                 (gethash buffer *site-zoomed-buffers*) t))
          ((gethash buffer *site-zoomed-buffers*)
           (remhash buffer *site-zoomed-buffers*)
           (setf (ffi-buffer-zoom-ratio buffer) (zoom-ratio-default buffer)
                 (ffi-buffer-sound-enabled-p buffer) t))))
  url)

(define-command-global toggle-mute (&optional (buffer (current-buffer)))
  "Mute or unmute BUFFER; `remember-site-modes' keeps it for the site."
  (let ((sound (not (ffi-buffer-sound-enabled-p buffer))))
    (setf (ffi-buffer-sound-enabled-p buffer) sound)
    (echo (if sound "Sound on" "Muted"))))

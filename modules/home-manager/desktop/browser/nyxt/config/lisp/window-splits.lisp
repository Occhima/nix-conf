(in-package #:nyxt-user)

(define-class split-panel (panel-buffer)
  ()
  (:export-class-name-p t)
  (:metaclass user-class)
  (:documentation "Panel opened by `split-right', browsing like the page beside it.

Nyxt 5 has no in-window splits, only side panels, so a split is a panel that
gets back the browsing modes panels drop and is not held to their 640px cap."))

(defmethod default-modes :around ((buffer split-panel))
  (remove-duplicates
   (append (call-next-method)
           '(base-mode
             nyxt/mode/document:document-mode
             nyxt/mode/hint:hint-mode
             nyxt/mode/search-buffer:search-buffer-mode
             nyxt/mode/history:history-mode))
   :from-end t))

(defun %strip-panel-chrome (panel)
  "Drop the title bar and buttons Nyxt injects into every panel's page."
  (ffi-buffer-evaluate-javascript-async
   panel
   (ps:ps
     (let ((chrome (ps:chain document (get-element-by-id "nyxt-panel-chrome")))
           (root (or (ps:@ document body) (ps:@ document document-element))))
       (when chrome
         (ps:chain chrome (remove)))
       (when (and root (ps:@ root dataset nyxt-panel-pad))
         (setf (ps:@ root style padding-top) "")
         (delete (ps:@ root dataset nyxt-panel-pad)))))))

(defmethod on-signal-load-finished :after ((buffer split-panel) url title)
  (declare (ignore url title))
  (%strip-panel-chrome buffer))

(defmethod (setf title) :after (value (panel split-panel))
  (declare (ignore value))
  (%strip-panel-chrome panel))

(defun %half-width (window)
  (floor (or (ignore-errors (ffi-width window)) 1600) 2))

;; ponytail: width is pixels, so a window resize leaves the split as it was; `balance-splits' redoes it.
(defmethod (setf nyxt::width) :around (value (panel split-panel))
  (setf (slot-value panel 'nyxt::width)
        (max 160 (min value (- (* 2 (%half-width (window panel))) 160))))
  (when (and (visible-p panel) (window panel))
    (nyxt::apply-panel-geometry panel))
  value)

(defun %split-views (window)
  "WINDOW's page and panels, left to right."
  (let ((panels (panel-buffers window)))
    (append (remove :right panels :key #'side)
            (list (buffer window))
            (remove :left panels :key #'side))))

(defun %split-at (buffer side)
  (let* ((window (window buffer))
         (panel (add-panel-buffer window (make-instance 'split-panel :side side))))
    (setf (nyxt::width panel) (%half-width window))
    (ffi-buffer-load panel (url buffer))
    (ffi-focus-buffer panel)
    panel))

(define-command-global split-right (buffer)
  "Show BUFFER's page again on the right, as Vim's `C-w v'."
  (%split-at buffer :right))

(define-command-global split-left (buffer)
  "Show BUFFER's page again on the left."
  (%split-at buffer :left))

(defun %focus-split (buffer delta)
  (let* ((views (%split-views (window buffer)))
         (index (or (position buffer views) 0)))
    (ffi-focus-buffer (nth (mod (+ index delta) (length views)) views))))

(define-command-global split-focus-next (buffer)
  "Move focus to the next split, wrapping around, as `C-w w'."
  (%focus-split buffer 1))

(define-command-global split-focus-left (buffer)
  "Move focus one split to the left, as `C-w h'."
  (%focus-split buffer -1))

(define-command-global split-focus-right (buffer)
  "Move focus one split to the right, as `C-w l'."
  (%focus-split buffer 1))

(defun %target-split (buffer)
  "BUFFER when it is a split, else the window's last one."
  (if (typep buffer 'split-panel)
      buffer
      (find-if (lambda (panel) (typep panel 'split-panel)) (reverse (panel-buffers (window buffer))))))

(define-command-global split-close (buffer)
  "Close the focused split, or the last one from the page, as `C-w q'."
  (alexandria:if-let ((panel (%target-split buffer)))
    (delete-panel-buffer panel)
    (echo-warning "No split to close.")))

(define-command-global split-only (buffer)
  "Close every split but the page, as `C-w o'."
  (dolist (panel (remove-if-not (lambda (panel) (typep panel 'split-panel)) (panel-buffers (window buffer))))
    (delete-panel-buffer panel)))

(define-command-global balance-splits (buffer)
  "Give the page and its splits equal widths, as `C-w ='."
  (let* ((window (window buffer))
         (splits (remove-if-not (lambda (panel) (typep panel 'split-panel)) (panel-buffers window)))
         (share (floor (or (ignore-errors (ffi-width window)) 1600)
                       (1+ (length splits)))))
    (dolist (panel splits)
      (setf (nyxt::width panel) share))))

(defun %resize-split (buffer delta)
  (alexandria:when-let ((panel (%target-split buffer)))
    (incf (nyxt::width panel) delta)))

(define-command-global widen-split (buffer)
  "Widen the split, as `C-w >'."
  (%resize-split buffer 80))

(define-command-global narrow-split (buffer)
  "Narrow the split, as `C-w <'."
  (%resize-split buffer -80))

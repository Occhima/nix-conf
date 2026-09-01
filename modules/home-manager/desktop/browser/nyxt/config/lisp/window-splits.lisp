(in-package #:nyxt-user)

(defvar *splits* (make-hash-table)
  "Window -> (:orientation O :buffers BUFFERS :focus INDEX :listener-p BOOLEAN).

Nyxt 4 deleted panel buffers, but the Electron renderer attaches every buffer to
its window as a child view, so a split is several views tiled over the window's
content area.  ORIENTATION is :vertical for side-by-side buffers, as in Vim's
:vsplit, or :horizontal for stacked ones.  BUFFERS is in visual order, and FOCUS
indexes the pane that holds the window's active buffer.")

(defun %chrome-height (window)
  "Pixels of WINDOW taken by the status and message buffers.

The prompt buffer is left out: this configuration floats it over the content
area as a palette rather than giving it a strip of its own."
  (+ (ffi-height (status-buffer window))
     (ffi-height (message-buffer window))))

(defun %split-state (window)
  (gethash window *splits*))

(defun %pane-buffers (window)
  "Buffers tiled in WINDOW, or its active buffer alone when it is not split."
  (alexandria:if-let ((buffers (getf (%split-state window) :buffers)))
    buffers
    (alexandria:when-let ((buffer (active-buffer window)))
      (list buffer))))

(defun %place-pane (window buffer x y width height)
  (electron:set-bounds buffer :x x :y y :width width :height height)
  (unless (find buffer (electron:views window))
    (electron:add-view window buffer)))

(defun %place-chrome (window width height)
  "Stretch WINDOW's status and message buffers along the bottom of the window."
  (let ((status (status-buffer window))
        (message (message-buffer window)))
    (electron:set-bounds message
                         :x 0 :y (- height (ffi-height message))
                         :width width :height (ffi-height message))
    (electron:set-bounds status
                         :x 0 :y (- height
                                    (ffi-height message)
                                    (ffi-height status))
                         :width width :height (ffi-height status))))

(defun %tile (window)
  "Lay WINDOW's panes over the area above the status and message buffers."
  (ignore-errors
   (alexandria:when-let* ((buffers (%pane-buffers window))
                          (bounds (electron:get-content-bounds window)))
     (let* ((vertical-p (eq (getf (%split-state window) :orientation) :vertical))
            (count (length buffers))
            (width (alexandria:assoc-value bounds :width))
            (height (max 0 (- (alexandria:assoc-value bounds :height)
                              (%chrome-height window))))
            (pane-width (if vertical-p (floor width count) width))
            (pane-height (if vertical-p height (floor height count))))
       (loop for buffer in buffers
             for index from 0
             for last-p = (= index (1- count))
             do (%place-pane window buffer
                             (if vertical-p (* index pane-width) 0)
                             (if vertical-p 0 (* index pane-height))
                             (if (and vertical-p last-p)
                                 (- width (* index pane-width))
                                 pane-width)
                             (if (and (not vertical-p) last-p)
                                 (- height (* index pane-height))
                                 pane-height)))
       (%place-chrome window width (alexandria:assoc-value bounds :height))))))

(defun %ensure-resize-listener (window)
  "Make WINDOW's layout on resize a single listener of ours.

Each listener `electron:add-bounded-view' installs pokes a socket whose Lisp
side runs in a thread of its own, so the one nyxt gave the focused pane races
this one and wins about as often, stretching that pane over the whole window.
Dropping the window's resize listeners settles the race; laying out the status
and message buffers in `%tile' is the price, since their listeners go too."
  (let ((state (%split-state window)))
    (unless (getf state :listener-p)
      (electron::message window
                         (format nil "~a.removeAllListeners('resize')"
                                 (electron:remote-symbol window)))
      (electron:add-listener window :resize
                             (lambda (&rest arguments)
                               (declare (ignore arguments))
                               (%tile window)))
      (setf (getf state :listener-p) t
            (gethash window *splits*) state))))

(defun %detach (window buffer)
  (when buffer
    (ignore-errors
     (electron:remove-view window buffer :kill-view-p nil))))

(defmethod ffi-window-set-buffer :around ((window nyxt/renderer/electron:electron-window)
                                          (buffer nyxt/renderer/electron:electron-buffer)
                                          &key (focus t))
  "Keep the other panes on screen when WINDOW's active buffer changes.

The primary method stretches the incoming buffer over the whole content area and
gives it a resize listener that would go on doing so, hence the bypass: a split
window lays out its own views.  Displaying a buffer that is already a pane moves
the focus there, which is how `switch-split' works.

Bypassing the primary method also bypasses the standard methods around it, so
the bookkeeping they do -- the hook, the access time, and `active-buffer', which
is what `window' of a buffer is derived from -- is repeated here."
  (alexandria:if-let ((buffers (getf (%split-state window) :buffers)))
    (let ((state (%split-state window))
          (index (position buffer buffers))
          (outgoing (nyxt/renderer/electron:current-view window)))
      (nhooks:run-hook (window-set-buffer-hook window) window buffer)
      (when focus (setf (last-access buffer) (local-time:now)))
      (if index
          (setf (getf state :focus) index)
          (let ((replaced (nth (getf state :focus) buffers)))
            (setf (nth (getf state :focus) buffers) buffer)
            (unless (eq replaced buffer)
              (%detach window replaced))))
      (setf (getf state :buffers) buffers
            (gethash window *splits*) state)
      (unless (find outgoing buffers)
        (%detach window outgoing))
      (%tile window)
      (when focus (electron:focus buffer))
      (setf (nyxt/renderer/electron:current-view window) buffer
            (active-buffer window) buffer)
      buffer)
    (call-next-method)))

(defmethod (setf ffi-height) :after ((height integer) (buffer status-buffer))
  (alexandria:when-let ((window (window buffer)))
    (%tile window)))

(defmethod (setf ffi-height) :after ((height integer) (buffer message-buffer))
  (alexandria:when-let ((window (window buffer)))
    (%tile window)))

(defmethod ffi-buffer-delete :after ((buffer nyxt/renderer/electron:electron-buffer))
  "Drop BUFFER from the split it was part of and give its room to the others."
  (maphash
   (lambda (window state)
     (when (member buffer (getf state :buffers))
       (let ((remaining (remove buffer (getf state :buffers))))
         (setf (getf state :buffers) remaining
               (getf state :focus) (max 0 (min (getf state :focus)
                                               (1- (length remaining))))
               (gethash window *splits*) state)
         (%tile window))))
   *splits*))

(defmethod ffi-window-delete :before ((window nyxt/renderer/electron:electron-window))
  (remhash window *splits*))

(defun %split (orientation)
  (let* ((window (current-window))
         (state (%split-state window))
         (buffers (or (getf state :buffers) (list (active-buffer window))))
         (focus (or (getf state :focus) 0))
         (partner (make-buffer :url (url (current-buffer)))))
    (setf (gethash window *splits*)
          (list :orientation orientation
                :buffers (append (subseq buffers 0 (1+ focus))
                                 (list partner)
                                 (subseq buffers (1+ focus)))
                :focus focus
                :listener-p (getf state :listener-p)))
    (%ensure-resize-listener window)
    (%tile window)
    (set-current-buffer partner)
    partner))

(define-command split-vertically ()
  "Show the current page in a pane beside this one, as in Vim's :vsplit."
  (%split :vertical))

(define-command split-horizontally ()
  "Show the current page in a pane below this one, as in Vim's :split."
  (%split :horizontal))

(define-command switch-split ()
  "Move to the next pane of a split window, as in Vim's C-w w."
  (let* ((window (current-window))
         (state (%split-state window))
         (buffers (getf state :buffers)))
    (if (rest buffers)
        (set-current-buffer
         (nth (mod (1+ (getf state :focus)) (length buffers)) buffers))
        (echo "Window is not split."))))

(defun %move-focus (direction)
  "Move to the pane DIRECTION of the focused one, as in Vim's C-w h j k l.

A window holds one row or one column of panes, never a grid, so only the
axis its orientation runs along can be moved along: DIRECTION across that
axis has nowhere to go.  Neither does DIRECTION off the end, which stops
where Vim stops rather than wrapping round to the far side."
  (let* ((window (current-window))
         (state (%split-state window))
         (buffers (getf state :buffers))
         (vertical-p (eq (getf state :orientation) :vertical))
         (step (case direction
                 (:left (and vertical-p -1))
                 (:right (and vertical-p 1))
                 (:up (and (not vertical-p) -1))
                 (:down (and (not vertical-p) 1)))))
    (if (rest buffers)
        (alexandria:when-let ((index (and step (+ (getf state :focus) step))))
          (when (and (<= 0 index) (< index (length buffers)))
            (set-current-buffer (nth index buffers))))
        (echo "Window is not split."))))

(define-command focus-split-left ()
  "Move to the pane left of this one, as in Vim's C-w h."
  (%move-focus :left))

(define-command focus-split-down ()
  "Move to the pane below this one, as in Vim's C-w j."
  (%move-focus :down))

(define-command focus-split-up ()
  "Move to the pane above this one, as in Vim's C-w k."
  (%move-focus :up))

(define-command focus-split-right ()
  "Move to the pane right of this one, as in Vim's C-w l."
  (%move-focus :right))

(define-command unsplit ()
  "Give the whole window back to the focused pane, as in Vim's :only.

The other buffers stay in the buffer list, as closing a Vim window leaves its
buffer loaded."
  (let* ((window (current-window))
         (state (%split-state window))
         (buffers (getf state :buffers)))
    (if (rest buffers)
        (let ((kept (nth (getf state :focus) buffers)))
          (dolist (buffer (remove kept buffers))
            (%detach window buffer))
          (setf (getf state :buffers) (list kept)
                (getf state :focus) 0
                (gethash window *splits*) state)
          (%tile window))
        (echo "Window is not split."))))

(define-configuration base-mode
  ((keyscheme-map
    ;; `C-w' is `delete-current-buffer' in cua and kills a region in emacs, and
    ;; `M-w' is taken as well, so the prefix is `C-M-w'.  The lists are spelled
    ;; out rather than shared through a variable, which the compiler macro of
    ;; `define-keyscheme-map' refuses.
    (keymaps:define-keyscheme-map
      "window-splits" (list :import %slot-value%)
      nyxt/keyscheme:default
      (list "C-M-w v" 'split-vertically
            "C-M-w s" 'split-horizontally
            "C-M-w w" 'switch-split
            "C-M-w h" 'focus-split-left
            "C-M-w j" 'focus-split-down
            "C-M-w k" 'focus-split-up
            "C-M-w l" 'focus-split-right
            "C-M-w o" 'unsplit)
      nyxt/keyscheme:cua
      (list "C-M-w v" 'split-vertically
            "C-M-w s" 'split-horizontally
            "C-M-w w" 'switch-split
            "C-M-w h" 'focus-split-left
            "C-M-w j" 'focus-split-down
            "C-M-w k" 'focus-split-up
            "C-M-w l" 'focus-split-right
            "C-M-w o" 'unsplit)
      nyxt/keyscheme:emacs
      (list "C-M-w v" 'split-vertically
            "C-M-w s" 'split-horizontally
            "C-M-w w" 'switch-split
            "C-M-w h" 'focus-split-left
            "C-M-w j" 'focus-split-down
            "C-M-w k" 'focus-split-up
            "C-M-w l" 'focus-split-right
            "C-M-w o" 'unsplit)
      nyxt/keyscheme:vi-normal
      (list "C-M-w v" 'split-vertically
            "C-M-w s" 'split-horizontally
            "C-M-w w" 'switch-split
            "C-M-w h" 'focus-split-left
            "C-M-w j" 'focus-split-down
            "C-M-w k" 'focus-split-up
            "C-M-w l" 'focus-split-right
            "C-M-w o" 'unsplit)))))

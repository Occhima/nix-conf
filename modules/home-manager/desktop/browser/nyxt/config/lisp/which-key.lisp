(in-package #:nyxt-user)

(defvar *which-key-delay* 0.4
  "Seconds to wait after a prefix key before showing its continuations.")

(defvar *which-key-max-height-ratio* 0.4
  "Largest share of the window the popup may cover; it scrolls past that.")

(defvar *which-key-labels* (make-hash-table :synchronized t :test 'equal)
  "Prefix keyspec -> group name shown instead of +prefix, as which-key's
replacement alist.  Filled by `define-leader-group'.")

(defvar *which-key-views* (make-hash-table :synchronized t :test 'eq :weakness :key)
  "Window -> the `message-buffer' used as that window's popup.

A `message-buffer' because Electron-side it is a bare view Nyxt already
knows how to write HTML into, and it is neither a `context-buffer' (so it
stays out of `buffer-list') nor attached to any page.  Drawing in a view of
our own, rather than in the page, is what keeps the popup working on pages
whose Trusted Types or CSP reject injected markup -- YouTube and Gmail --
and keeps the page from reflowing under it.")

(defvar *which-key-shown* (make-hash-table :synchronized t :test 'eq :weakness :key)
  "Window -> T while its popup is attached.")

(defun %binding-label (value)
  (string-downcase
   (typecase value
     (symbol (symbol-name value))
     (command (symbol-name (name value)))
     (t (princ-to-string value)))))

(defun %which-key-entries (keymaps prefix)
  "Sorted (KEY LABEL PREFIX-P) for every key that can follow PREFIX in KEYMAPS.

Candidates are gathered from every keymap and its parents, then each is
resolved with `keymaps:lookup-key' itself, so shadowing, parent order and key
translation match what pressing the key would really run."
  (let ((start (str:concat prefix " "))
        (candidates '()))
    (dolist (keymap keymaps)
      (maphash (lambda (keyspec value)
                 (declare (ignore value))
                 (when (str:starts-with-p start keyspec)
                   (pushnew (first (str:split " " (subseq keyspec (length start))))
                            candidates :test #'string=)))
               (keymaps:keymap-with-parents->map keymap)))
    (sort (loop for key in candidates
                for keyspec = (str:concat start key)
                for bound = (ignore-errors (keymaps:lookup-key keyspec keymaps))
                when bound
                  collect (if (keymaps:keymap-p bound)
                              (list key (gethash keyspec *which-key-labels* "+prefix") t)
                              (list key (%binding-label bound) nil)))
          #'string< :key #'first)))

(defun %which-key-css ()
  (theme:themed-css (theme *browser*)
    `(body
      :margin "0"
      :box-sizing "border-box"
      :height "100vh"
      :overflow-y "auto"
      :padding "10px 16px 12px"
      :background-color ,theme:background-color
      :color ,theme:on-background-color
      :border-top ,(format nil "1px solid ~a" (%hairline theme:on-background-color 0.12))
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "12px"
      :line-height "18px")
    `(".wk-prefix"
      :color ,theme:primary-color
      :font-size "10px"
      :letter-spacing "0.10em"
      :text-transform "uppercase"
      :margin-bottom "8px")
    '(".wk-grid"
      :display "grid"
      :grid-template-columns "repeat(auto-fill, minmax(220px, 1fr))"
      :gap "0 24px")
    '(".wk-item"
      :display "flex"
      :gap "10px"
      :white-space "nowrap"
      :overflow "hidden")
    `(".wk-key"
      :flex "0 0 auto"
      :min-width "3ch"
      :color ,theme:action-color)
    `(".wk-cmd"
      :overflow "hidden"
      :text-overflow "ellipsis"
      :color ,theme:primary-color)
    `(".wk-cmd.prefix"
      :color ,theme:highlight-color)))

(defun %which-key-html (prefix entries)
  "Body markup for `ffi-print-message', which wraps it in the view's own head."
  (spinneret:with-html-string
    (:style (:raw (%which-key-css)))
    (:div.wk-prefix prefix)
    (:div.wk-grid
     (loop for (key label prefix-p) in entries
           do (:div.wk-item
               (:span.wk-key key)
               (:span :class (if prefix-p "wk-cmd prefix" "wk-cmd") label))))))

(defun %which-key-view (window)
  "WINDOW's popup view, made on first use.

Made while the prefix delay runs, not when showing: the view loads
about:blank asynchronously, and HTML written before that load would be lost."
  (or (gethash window *which-key-views*)
      (setf (gethash window *which-key-views*)
            (make-instance 'message-buffer :window window))))

(defun %which-key-height (entries width window-height)
  (let* ((columns (max 1 (floor (- width 32) 244)))
         (rows (ceiling (length entries) columns)))
    (min (+ 40 (* 18 rows))
         (floor (* window-height *which-key-max-height-ratio*)))))

(defun %which-key-show (window prefix entries)
  (alexandria:when-let* ((view (%which-key-view window))
                         (bounds (electron:get-content-bounds window)))
    (let* ((width (alexandria:assoc-value bounds :width))
           (window-height (alexandria:assoc-value bounds :height))
           (height (%which-key-height entries width window-height)))
      (ffi-print-message view (%which-key-html prefix entries))
      (electron:set-bounds view
                           :x 0
                           :y (- window-height (%chrome-height window) height)
                           :width width
                           :height height)
      ;; `add-view' on a view already attached raises it to the top instead.
      (electron:add-view window view)
      (setf (gethash window *which-key-shown*) t))))

(defun %which-key-hide (window)
  (when (gethash window *which-key-shown*)
    (setf (gethash window *which-key-shown*) nil)
    (alexandria:when-let ((view (gethash window *which-key-views*)))
      (electron:remove-view window view :kill-view-p nil))))

(define-mode which-key-mode ()
  "Show the keys that can follow a prefix key, like Emacs' which-key."
  ((visible-in-status-p nil)))

;; Electron calls this in a thread of its own per key, right before
;; `dispatch-input-event' runs on the key stack, so sleeping here delays
;; nothing but the popup.  The stack still holding the same keys after the
;; delay is what tells a pause on a prefix from a sequence typed through.
(defmethod on-signal-key-press ((mode which-key-mode) key)
  (declare (ignore key))
  (ignore-errors
   (let* ((buffer (buffer mode))
          (window (window buffer))
          (stack (copy-list (nyxt::key-stack buffer)))
          (keymaps (current-keymaps buffer)))
     (when window
       (if (and stack (keymaps:keymap-p (keymaps:lookup-key stack keymaps)))
           (progn
             (%which-key-view window)
             (sleep *which-key-delay*)
             (when (equal stack (nyxt::key-stack buffer))
               (let ((prefix (keymaps:keys->keyspecs stack)))
                 (%which-key-show window prefix (%which-key-entries keymaps prefix)))))
           (%which-key-hide window))))))

(define-configuration web-buffer
  ((default-modes (cons 'which-key-mode %slot-value%))))

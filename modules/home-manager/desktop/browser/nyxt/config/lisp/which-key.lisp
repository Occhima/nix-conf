(in-package #:nyxt-user)

(defvar *which-key-delay* 0.4
  "Seconds to wait after a prefix key before showing its continuations.")

(defvar *which-key-shown* (make-hash-table :test 'eq :weakness :key))

(defun %binding-name (value)
  (string-downcase
   (typecase value
     (symbol (symbol-name value))
     (command (symbol-name (name value)))
     (t (princ-to-string value)))))

(defun %which-key-entries (buffer prefix)
  "Sorted (KEY . LABEL) for every binding in BUFFER's keymaps that follows PREFIX."
  (let ((entries (make-hash-table :test 'equal))
        (start (str:concat prefix " ")))
    (maphash (lambda (keyspec value)
               (when (str:starts-with-p start keyspec)
                 (let* ((rest (subseq keyspec (length start)))
                        (next (first (str:split " " rest))))
                   (unless (gethash next entries)
                     (setf (gethash next entries)
                           (if (find #\Space rest)
                               "+prefix"
                               (%binding-name value)))))))
             (apply #'keymaps:keymap->map
                    (mapcan #'keymaps::keymap-with-parents
                            (nyxt::current-keymaps buffer))))
    (sort (alexandria:hash-table-alist entries) #'string< :key #'car)))

(defun %which-key-css ()
  (theme:themed-css (theme *browser*)
    `(".wk"
      :box-sizing "border-box"
      :max-height "40vh"
      :overflow-y "auto"
      :padding "10px 16px 12px"
      :background-color ,theme:background-color
      :color ,theme:on-background-color
      :border-top ,(format nil "1px solid ~a" (%hairline theme:on-background-color 0.12))
      :box-shadow "0 -8px 24px rgba(0,0,0,0.35)"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "12px")
    `(".wk-prefix"
      :color ,theme:primary-color
      :font-size "10px"
      :letter-spacing "0.10em"
      :text-transform "uppercase"
      :margin-bottom "8px")
    '(".wk-grid"
      :display "grid"
      :grid-template-columns "repeat(auto-fill, minmax(220px, 1fr))"
      :gap "4px 24px")
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

(defun %which-key-show (buffer prefix entries)
  (let ((html (spinneret:with-html-string
                (:style (:raw (%which-key-css)))
                (:div.wk
                 (:div.wk-prefix prefix)
                 (:div.wk-grid
                  (loop for (key . label) in entries
                        do (:div.wk-item
                            (:span.wk-key key)
                            (:span :class (if (string= label "+prefix") "wk-cmd prefix" "wk-cmd")
                                   label))))))))
    (setf (gethash buffer *which-key-shown*) t)
    (ffi-buffer-evaluate-javascript-async
     buffer
     (ps:ps
       (let ((old (ps:chain document (get-element-by-id "nyxt-which-key"))))
         (when old (ps:chain old (remove))))
       (let ((host (ps:chain document (create-element "div"))))
         (setf (ps:@ host id) "nyxt-which-key"
               (ps:chain host style css-text)
               "all: initial; position: fixed; left: 0; right: 0; bottom: 0; z-index: 2147483647;")
         (setf (ps:chain host (attach-shadow (ps:create mode "open")) inner-h-t-m-l)
               (ps:lisp html))
         (ps:chain document document-element (append-child host)))))))

(defun %which-key-hide (buffer)
  (when (gethash buffer *which-key-shown*)
    (setf (gethash buffer *which-key-shown*) nil)
    (ffi-buffer-evaluate-javascript-async
     buffer
     (ps:ps
       (let ((host (ps:chain document (get-element-by-id "nyxt-which-key"))))
         (when host (ps:chain host (remove))))))))

(define-mode which-key-mode ()
  "Show the keys that can follow a prefix key, like Emacs' which-key."
  ((visible-in-status-p nil)))

(defmethod on-signal-key-press ((mode which-key-mode) key)
  (declare (ignore key))
  (let* ((buffer (buffer mode))
         (stack (copy-list (nyxt::key-stack buffer))))
    (if (and stack
             (keymaps:keymap-p (keymaps:lookup-key stack (nyxt::current-keymaps buffer))))
        (progn
          (sleep *which-key-delay*)
          (when (equal stack (nyxt::key-stack buffer))
            (let ((prefix (keymaps:keys->keyspecs stack)))
              (%which-key-show buffer prefix (%which-key-entries buffer prefix)))))
        (%which-key-hide buffer))))

(define-configuration web-buffer
  ((default-modes (cons 'which-key-mode %slot-value%))))

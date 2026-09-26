(in-package #:nyxt-user)

;; Stock `vi-insert-on-input-fields' asks the page for its focused element from
;; inside Electron's blocking key handler (deadlock), and the Electron renderer
;; never sends the clicks that would call it.  Focus changes come from the page
;; instead, see `vi-focus-mode'.
(sb-ext:with-unlocked-packages (:nyxt/mode/vi)
  (setf (fdefinition 'nyxt/mode/vi::vi-insert-on-input-fields)
        (lambda (buffer) (declare (ignore buffer)) nil)))

(defparameter *vi-focus-script*
  "(() => {
  if (window.__nyxtVi) return;
  window.__nyxtVi = true;
  const skip = ['button', 'checkbox', 'radio', 'submit', 'reset', 'image', 'file', 'color', 'range', 'hidden'];
  const editable = (el) => el && (el.isContentEditable || el.tagName === 'TEXTAREA' || el.tagName === 'SELECT'
                                  || (el.tagName === 'INPUT' && !skip.includes(el.type)));
  const report = (state) => (e) => { if (editable(e.composedPath()[0])) console.log('nyxt-vi:' + state); };
  document.addEventListener('focusin', report('insert'), true);
  document.addEventListener('focusout', report('normal'), true);
})();")

(defvar *vi-focus-listening* (make-hash-table :test 'eq :weakness :key))

(defun %vi-focus-changed (buffer state)
  (cond ((and (equal state "nyxt-vi:insert")
              (find-submode 'nyxt/mode/vi:vi-normal-mode buffer))
         (enable-modes* 'nyxt/mode/vi:vi-insert-mode buffer))
        ((and (equal state "nyxt-vi:normal")
              (find-submode 'nyxt/mode/vi:vi-insert-mode buffer))
         (enable-modes* 'nyxt/mode/vi:vi-normal-mode buffer))))

(defun %vi-listen-for-focus (buffer)
  "Forward the page's `nyxt-vi:' console messages to `%vi-focus-changed'."
  (let ((contents (electron:web-contents buffer)))
    (multiple-value-bind (thread-id socket-thread)
        (electron::create-node-socket-thread
         (lambda (arguments) (%vi-focus-changed buffer (first arguments)))
         :interface (electron::interface contents))
      (push socket-thread (electron:socket-threads contents))
      (electron::message
       contents
       (format nil "~a.on('console-message', (event, level, message) => {
                      const m = (event && event.message) || message;
                      if (typeof m === 'string' && m.startsWith('nyxt-vi:'))
                        ~a.write(JSON.stringify([m]) + '\\n');
                    })"
               (electron:remote-symbol contents) thread-id)))))

(define-mode vi-focus-mode ()
  "Enter vi insert mode when a page field gains focus, normal mode when it loses it."
  ((visible-in-status-p nil)))

(defmethod on-signal-load-finished ((mode vi-focus-mode) url title)
  (declare (ignore title))
  (let ((buffer (buffer mode)))
    (unless (gethash buffer *vi-focus-listening*)
      (setf (gethash buffer *vi-focus-listening*) t)
      (%vi-listen-for-focus buffer))
    (ffi-buffer-evaluate-javascript-async buffer *vi-focus-script*))
  url)

(define-command vi-escape ()
  "Close the open prompt; otherwise leave insert mode and unfocus the field."
  (alexandria:if-let ((prompt (current-prompt-buffer)))
    (nyxt/mode/prompt-buffer:quit-prompt-buffer prompt)
    (progn
      (nyxt/mode/vi:unfocus-current-element)
      (nyxt/mode/vi:switch-to-vi-normal-mode))))

(define-configuration web-buffer
  ((default-modes (list* 'nyxt/mode/vi:vi-normal-mode 'vi-focus-mode %slot-value%))))

(define-configuration nyxt/mode/vi:vi-insert-mode
  ((keyscheme-map
    (keymaps:define-keyscheme-map "nyxt-user-vi-insert" ()
      nyxt/keyscheme:vi-insert
      (list "C-z" 'nyxt/mode/passthrough:passthrough-mode
            "escape" 'vi-escape)))))

(define-configuration nyxt/mode/vi:vi-normal-mode
  ((keyscheme-map
    (keymaps:define-keyscheme-map "nyxt-user-vi-normal" (list :import %slot-value%)
      nyxt/keyscheme:vi-normal
      (list "o" 'set-url
            "t" 'set-url-new-buffer
            "b" 'switch-buffer
            "x" 'delete-current-buffer
            "r" 'reload-current-buffer
            "H" 'history-backwards
            "L" 'history-forwards
            "J" 'switch-buffer-next
            "K" 'switch-buffer-previous
            "f" 'nyxt/mode/hint:follow-hint
            "F" 'nyxt/mode/hint:follow-hint-new-buffer
            "/" 'nyxt/mode/search-buffer:search-buffer
            "g /" 'nyxt/mode/search-buffer:search-buffers
            "y u" 'copy-url
            ":" 'execute-command
            "g s" 'start-page
            "g e" 'open-in-emacs
            "g r" 'capture-in-org-roam
            "g a" 'add-paper
            "g l" 'read-later
            "g m" 'reader-mode)))))

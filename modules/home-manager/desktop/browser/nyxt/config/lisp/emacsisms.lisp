(in-package #:nyxt-user)

(defvar *registers-file*
  (merge-pathnames "nyxt/registers.lisp" (uiop:xdg-data-home)))

(defvar *registers*
  (ignore-errors (uiop:read-file-form *registers-file*))
  "List of (NAME URL TITLE SCROLL-Y).")

(defun %save-registers ()
  (ensure-directories-exist *registers-file*)
  (with-open-file (out *registers-file* :direction :output :if-exists :supersede)
    (with-standard-io-syntax
      (prin1 *registers* out))))

(define-class register-source (prompter:source)
  ((prompter:name "Registers")
   (prompter:constructor (lambda (source)
                           (declare (ignore source))
                           *registers*))
   (prompter:filter-preprocessor #'prompter:filter-exact-matches)))

(defmethod prompter:object-attributes ((entry cons) (source register-source))
  (destructuring-bind (name url title &rest _) entry
    (declare (ignore _))
    `(("Register" ,name) ("Title" ,title) ("URL" ,url))))

(define-command-global point-to-register (&optional (buffer (current-buffer)))
  "Save the current page and scroll position under a name."
  (let ((name (prompt1 :prompt "Point to register"
                       :sources (make-instance 'prompter:raw-source))))
    (unless (str:blankp name)
      (setf *registers*
            (cons (list name
                        (render-url (url buffer))
                        (title buffer)
                        (or (ignore-errors (ps-eval :buffer buffer (ps:@ window scroll-y))) 0))
                  (remove name *registers* :key #'first :test #'string=)))
      (%save-registers)
      (echo "Register ~a: ~a" name (title buffer)))))

(define-command-global jump-to-register (&optional (buffer (current-buffer)))
  "Go back to a page and scroll position saved with `point-to-register'."
  (alexandria:when-let ((entry (prompt1 :prompt "Jump to register"
                                        :sources (make-instance 'register-source))))
    (destructuring-bind (name url title y) entry
      (declare (ignore name title))
      (if (string= url (render-url (url buffer)))
          (ps-eval :buffer buffer (ps:chain window (scroll-to 0 (ps:lisp y))))
          (progn
            (%scroll-after-load buffer y)
            (ffi-buffer-load buffer (quri:uri url)))))))

(define-command-global forget-register ()
  "Delete a register."
  (alexandria:when-let ((entry (prompt1 :prompt "Forget register"
                                        :sources (make-instance 'register-source))))
    (setf *registers* (remove entry *registers* :test #'equal))
    (%save-registers)
    (echo "Forgot register ~a" (first entry))))

(defparameter *narrow-selector*
  "main, article, section, aside, nav, header, footer, div, table, pre, figure, form, ul, ol, blockquote, p"
  "Elements `narrow-to-element' offers as hints.")

(defun narrow-to (element &optional (buffer (current-buffer)))
  "Hide everything on the page except ELEMENT, as `narrow-to-region' does."
  (ps-eval :buffer buffer
    (let* ((target (nyxt/ps:qs-nyxt-id document (ps:lisp (nyxt/dom:get-nyxt-id element))))
           (node target))
      (loop while (and node (ps:@ node parent-element))
            do (dolist (sibling (ps:chain *array (from (ps:@ node parent-element children))))
                 (unless (or (eq sibling node)
                             (ps:chain sibling (has-attribute "data-nyxt-narrowed")))
                   (ps:chain sibling (set-attribute "data-nyxt-narrowed"
                                                    (ps:@ sibling style display)))
                   (setf (ps:@ sibling style display) "none")))
               (setf node (ps:@ node parent-element)))
      (when target
        (ps:chain target (scroll-into-view))))))

(define-command-global narrow-to-element ()
  "Hint an element and hide the rest of the page; `widen' brings it back."
  (nyxt/mode/hint:query-hints
   "Narrow to"
   (lambda (elements)
     (when elements
       (narrow-to (first elements))))
   :enable-marks-p nil
   :selector *narrow-selector*))

(define-command-global widen (&optional (buffer (current-buffer)))
  "Show again what `narrow-to-element' hid."
  (ps-eval :buffer buffer
    (dolist (element (ps:chain *array (from (nyxt/ps:qsa document "[data-nyxt-narrowed]"))))
      (setf (ps:@ element style display)
            (ps:chain element (get-attribute "data-nyxt-narrowed")))
      (ps:chain element (remove-attribute "data-nyxt-narrowed")))))

(define-command-global copy-from-clipboard-ring ()
  "Put an earlier clipboard entry back on the clipboard, like `consult-yank-pop'."
  (nyxt::ring-insert-clipboard (nyxt::clipboard-ring *browser*))
  (alexandria:when-let
      ((text (prompt1 :prompt "Copy from ring"
                      :sources (make-instance 'nyxt/mode/document::ring-source
                                              :ring (nyxt::clipboard-ring *browser*)
                                              :actions-on-return #'identity))))
    (copy-to-clipboard text)
    (echo "Copied ~a" (str:shorten 60 text))))

(defvar *macro* '()
  "Commands of the last recorded macro, oldest first.")

(defvar *macro-recording* nil
  "Commands run since `start-macro', newest first, or NIL when not recording.")

(defparameter *macro-commands* '(start-macro end-macro call-macro)
  "Commands left out of a recording.")

(defun %recording-dispatcher (command)
  (unless (member (nyxt::name command) *macro-commands*)
    (push command *macro-recording*))
  (nyxt::dispatch-command command))

(define-command-global start-macro ()
  "Record the commands run from keys until `end-macro', as Emacs's `kmacro'."
  (setf *macro-recording* '()
        (command-dispatcher *browser*) #'%recording-dispatcher)
  (echo "Defining macro..."))

(define-command-global end-macro ()
  "Stop recording and keep the commands as the macro `call-macro' replays."
  (setf (command-dispatcher *browser*) #'nyxt::dispatch-command
        *macro* (reverse *macro-recording*)
        *macro-recording* nil)
  (echo "Macro of ~a commands" (length *macro*)))

(define-command-global call-macro (&optional (count 1))
  "Replay the last macro COUNT times."
  (if *macro*
      (loop repeat count
            do (dolist (command *macro*)
                 (nyxt::run-command command)))
      (echo-warning "No macro recorded.")))

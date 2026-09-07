(in-package #:nyxt-user)

(define-class passage-interface (password:password-store-interface)
  ((password:executable "passage")
   (password::password-directory
    (or (uiop:getenv "PASSAGE_DIR")
        (format nil "~a/.config/secrets/store" (uiop:getenv "HOME")))))
  (:documentation "`passage' as Nyxt's password manager.

`passage' keeps the password-store CLI but encrypts with age, so entries end in
.age rather than .gpg and `list-passwords' has to glob for those instead."))

(defmethod password:list-passwords ((interface passage-interface))
  (alexandria:when-let
      ((directory (uiop:truename*
                   (uiop:parse-native-namestring
                    (password::password-directory interface)))))
    (let ((prefix (length (namestring directory))))
      (mapcar (lambda (path)
                (let ((entry (namestring path)))
                  (subseq entry prefix (- (length entry) (length ".age")))))
              (uiop:directory* (format nil "~a/**/*.age" directory))))))

(define-configuration nyxt/mode/password:password-mode
  ((nyxt/mode/password:password-interface (make-instance 'passage-interface))))

(defun %read-until-pin-prompt (pty)
  "Read PTY a character at a time until the plugin's PIN prompt appears or
PTY hits EOF.  Returns T in the former case, NIL in the latter.

Reading has to happen a character at a time rather than a line at a time:
the prompt (\"Enter PIN for YubiKey with serial ...: \") never ends in a
newline, since it expects the answer typed on the same line, so `read-line'
would just block forever waiting for one that is never coming."
  (let ((seen (make-array 0 :element-type 'character :adjustable t :fill-pointer 0)))
    (loop
      (let ((char (read-char pty nil nil)))
        (unless char (return nil))
        (vector-push-extend char seen)
        (when (search "Enter PIN" seen) (return t))))))

(defun %run-passage-with-pin-prompt (arguments)
  "Run `passage' ARGUMENTS under a pty, answering an interactive YubiKey PIN
prompt via Nyxt's own prompt-buffer if the plugin asks for one.  Returns T
on a clean exit.

Nothing Nyxt hands a subprocess is ever a real terminal, and the YubiKey
plugin's PIN entry (Go's `term.ReadPassword') needs one -- it calls tty
ioctls that fail outright on a plain pipe.  SBCL's `:pty' support in
`run-program' allocates that terminal directly, so the requirement is met
regardless of what nyxt/mode/password's own, unrelated subprocess call
does.  An unanswered or empty PIN kills the child rather than forwarding a
blank line -- a prompt nobody answered must never turn into a submitted
attempt against the hardware."
  (let* ((executable (password:executable (make-instance 'passage-interface)))
         (process (sb-ext:run-program executable arguments
                                      :pty t :wait nil :search t)))
    (let ((pty (sb-ext:process-pty process)))
      (when (%read-until-pin-prompt pty)
        (let ((pin (prompt1 :prompt "YubiKey PIN"
                            :sources (list (make-instance 'prompter:raw-source)))))
          (if (and pin (plusp (length pin)))
              (progn (write-line pin pty) (force-output pty))
              (sb-ext:process-kill process 15)))))
    (sb-ext:process-wait process)
    (eql 0 (sb-ext:process-exit-code process))))

(define-command-global copy-password-pin ()
  "Copy a password to the clipboard, prompting for a YubiKey PIN through
Nyxt's own prompt-buffer if the store's identity needs one.

The built-in password-copy command hangs indefinitely on a YubiKey-backed
identity: it hands `passage' a subprocess with no interactive terminal, so
the plugin's PIN prompt sits blocked forever with no indication anything is
waiting on you.  This bypasses that flow entirely rather than patching it,
since neither its subprocess call nor its stdin handling is something this
configuration can reach into and change."
  (let ((entry (prompt1 :prompt "Password"
                        :sources (list (make-instance 'prompter:source
                                                      :name "Passwords"
                                                      :constructor
                                                      (lambda (source)
                                                        (declare (ignore source))
                                                        (password:list-passwords
                                                         (make-instance 'passage-interface))))))))
    (when entry
      (if (%run-passage-with-pin-prompt (list "show" "--clip" entry))
          (echo "Copied ~a to clipboard." entry)
          (echo-warning "Could not copy ~a." entry)))))

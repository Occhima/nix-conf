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

(defun %run-passage-with-pin (entry pin)
  "Run `passage show --clip' for ENTRY, feeding PIN to its terminal prompt.
Returns T on a clean exit.

`passage' insists on reading the YubiKey PIN from a terminal: the plugin has
no pinentry integration, no environment variable and no stdin support, so a
subprocess with plain pipes (what nyxt/mode/password hands it) has no prompt
to answer and blocks forever.  `script' allocates that terminal instead, and
the PIN is piped into it.  ENTRY and PIN travel as environment variables so
neither shows up in the process list; output is discarded -- the clipboard
is the only side effect that matters, and discarding keeps any pty echo of
the PIN out of Nyxt's logs and prompts."
  (let ((process (sb-ext:run-program
                  "bash"
                  (list "-c" "cmd=$(printf 'passage show --clip -- %q' \"$PASSAGE_ENTRY\")
printf '%s\\n' \"$PASSAGE_PIN\" | script -qec \"$cmd\" /dev/null >/dev/null 2>&1")
                  :search t :wait t :input nil :output nil :error nil
                  :environment (cons (format nil "PASSAGE_ENTRY=~a" entry)
                                     (cons (format nil "PASSAGE_PIN=~a" pin)
                                           (sb-ext:posix-environ))))))
    (eql 0 (sb-ext:process-exit-code process))))

(define-command-global copy-password-pin ()
  "Copy a password to the clipboard, asking for the YubiKey PIN first.

Nyxt's own password-copy hands `passage' a subprocess with no terminal, so
the PIN prompt blocks forever.  This asks here instead and feeds the answer
to a one-shot `script' invocation -- prompt, pipe, cleaned up, done."
  (let ((entry (prompt1 :prompt "Password"
                        :sources (list (make-instance 'prompter:source
                                                      :name "Passwords"
                                                      :constructor
                                                      (lambda (source)
                                                        (declare (ignore source))
                                                        (password:list-passwords
                                                         (make-instance 'passage-interface))))))))
    (when entry
      (let ((pin (prompt1 :prompt "YubiKey PIN"
                          :sources (list (make-instance 'prompter:raw-source)))))
        (cond ((or (null pin) (string= pin ""))
               (echo-warning "No PIN entered; ~a was not copied." entry))
              ((%run-passage-with-pin entry pin)
               (echo "Copied ~a to clipboard." entry))
              (t
               (echo-warning "Could not copy ~a." entry)))))))

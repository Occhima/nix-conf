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

(defun %run-passage-with-pin (entry pin &key output)
  "Run `passage show --clip' for ENTRY, feeding PIN to its terminal prompt.
Returns T on a clean exit.  With OUTPUT, a pathname, the decrypted entry is
written there instead of being copied.

`passage' insists on reading the YubiKey PIN from a terminal: the plugin has
no pinentry integration, no environment variable and no stdin support, so a
subprocess with plain pipes (what nyxt/mode/password hands it) has no prompt
to answer and blocks forever.  `script' allocates that terminal instead, and
the PIN is piped into it.  ENTRY, PIN and OUTPUT travel as environment
variables so none shows up in the process list; the terminal's output is
discarded, which keeps any pty echo of the PIN out of Nyxt's logs and
prompts.  OUTPUT is written through a redirection of `passage' itself, so the
secret never passes through that terminal."
  (let ((process (sb-ext:run-program
                  "bash"
                  (list "-c" "if [ -n \"$PASSAGE_OUT\" ]; then
  cmd=$(printf 'umask 077; passage show -- %q > %q' \"$PASSAGE_ENTRY\" \"$PASSAGE_OUT\")
else
  cmd=$(printf 'passage show --clip -- %q' \"$PASSAGE_ENTRY\")
fi
printf '%s\\n' \"$PASSAGE_PIN\" | script -qec \"$cmd\" /dev/null >/dev/null 2>&1")
                  :search t :wait t :input nil :output nil :error nil
                  :environment (append
                                (list (format nil "PASSAGE_ENTRY=~a" entry)
                                      (format nil "PASSAGE_PIN=~a" pin))
                                (when output
                                  (list (format nil "PASSAGE_OUT=~a"
                                                (uiop:native-namestring output))))
                                (sb-ext:posix-environ)))))
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

(defun %host-password-entries (url entries)
  "ENTRIES with a path component naming URL's host, domain or site name."
  (alexandria:when-let ((host (quri:uri-host url)))
    (let* ((domain (or (quri:uri-domain url) host))
           (names (list host domain (first (str:split "." domain)))))
      (remove-if-not (lambda (entry)
                       (intersection names (str:split "/" entry) :test #'string-equal))
                     entries))))

(defun %parse-password-entry (entry text)
  "Values PASSWORD and USERNAME from the decrypted TEXT of ENTRY.

The username is the first `login:', `user:', `username:' or `email:' line,
else the entry's file name, as in pass's site/username layout."
  (let ((lines (str:lines text)))
    (values (first lines)
            (or (loop for line in (rest lines)
                      for (key value) = (str:split ":" line :limit 2)
                      when (and value
                                (member (str:trim key) '("login" "user" "username" "email")
                                        :test #'string-equal))
                        return (str:trim value))
                (alexandria:lastcar (str:split "/" entry))))))

(defparameter *fill-login-js*
  "(function (user, pass) {
  var visible = function (e) {
    return e.offsetParent !== null && !e.disabled && !e.readOnly;
  };
  var set = function (e, v) {
    Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(e, v);
    e.dispatchEvent(new Event('input', {bubbles: true}));
    e.dispatchEvent(new Event('change', {bubbles: true}));
  };
  var inputs = Array.from(document.querySelectorAll('input')).filter(visible);
  var pw = inputs.find(function (e) { return e.type === 'password'; });
  var before = pw ? inputs.slice(0, inputs.indexOf(pw)) : inputs;
  var un = before.filter(function (e) {
    return ['text', 'email', 'tel'].indexOf(e.type) >= 0;
  }).pop();
  if (un) { set(un, user); }
  if (pw) { set(pw, pass); pw.focus(); } else if (un) { un.focus(); }
  return (un ? 1 : 0) + (pw ? 2 : 0);
})(~a, ~a);"
  "Fills the last visible text field before the first visible password field,
and that password field.  The native value setter plus input events is what
React and Vue forms need to notice the change.  A username-only step, as in
two-page logins, gets just the username.")

(defun %js-string (string)
  (cl-json:encode-json-to-string string))

(define-command-global fill-login (&optional (buffer (current-buffer)))
  "Fill the page's login form from the passage entry matching its host.

Unlike `copy-password-pin', the password never reaches the clipboard."
  (let* ((entries (password:list-passwords (make-instance 'passage-interface)))
         (matches (%host-password-entries (url buffer) entries))
         (entry (if (= 1 (length matches))
                    (first matches)
                    (prompt1 :prompt "Login"
                             :sources (list (make-instance 'prompter:source
                                                           :name "Passwords"
                                                           :constructor (or matches entries))))))
         (pin (when entry
                (prompt1 :prompt (format nil "YubiKey PIN for ~a" entry)
                         :sources (list (make-instance 'prompter:raw-source)))))
         (file (merge-pathnames (format nil "nyxt-login-~a" (random most-positive-fixnum))
                                (uiop:ensure-directory-pathname
                                 (or (uiop:getenv "XDG_RUNTIME_DIR") "/tmp")))))
    (cond ((null entry))
          ((or (null pin) (string= pin ""))
           (echo-warning "No PIN entered; ~a was not filled." entry))
          (t
           (unwind-protect
                (if (and (%run-passage-with-pin entry pin :output file)
                         (probe-file file))
                    (multiple-value-bind (password username)
                        (%parse-password-entry entry (alexandria:read-file-into-string file))
                      (let ((filled (ffi-buffer-evaluate-javascript
                                     buffer
                                     (format nil *fill-login-js*
                                             (%js-string username)
                                             (%js-string (or password ""))))))
                        (case (and (numberp filled) (round filled))
                          (3 (echo "Filled ~a." entry))
                          (1 (echo "Filled the username of ~a; no password field yet." entry))
                          (2 (echo "Filled the password of ~a; no username field found." entry))
                          (t (echo-warning "No login form on this page.")))))
                    (echo-warning "Could not decrypt ~a." entry))
             (uiop:delete-file-if-exists file))))))

(in-package #:nyxt-user)

(defvar *userscript-directories*
  (list (merge-pathnames "nyxt/userscripts/" (uiop:xdg-data-home))
        (merge-pathnames "userscripts/" (uiop:pathname-parent-directory-pathname
                                         (uiop:pathname-directory-pathname *load-truename*))))
  "Directories searched for Greasemonkey-style *.user.js files.

The first is writable; the second ships with this configuration.")

(defun %userscript-metadata (source)
  "Alist of (KEY . VALUE) from SOURCE's ==UserScript== block, in order."
  (let ((in-block nil)
        (metadata '()))
    (dolist (line (str:lines source) (nreverse metadata))
      (let ((line (str:trim line)))
        (cond ((search "==UserScript==" line) (setf in-block t))
              ((search "==/UserScript==" line) (return (nreverse metadata)))
              (in-block
               (multiple-value-bind (match groups)
                   (cl-ppcre:scan-to-strings "^//\\s*@(\\S+)\\s*(.*)$" line)
                 (when match
                   (push (cons (aref groups 0) (str:trim (aref groups 1))) metadata)))))))))

(defun %userscript-pattern-regex (pattern)
  "Anchored regex for an @include/@match/@exclude PATTERN.

`/regex/' is used as is.  Otherwise `*' matches anything, and a `*.' right
after the scheme also matches the bare domain, as @match specifies."
  (if (and (> (length pattern) 1)
           (str:starts-with-p "/" pattern)
           (str:ends-with-p "/" pattern))
      (subseq pattern 1 (1- (length pattern)))
      (flet ((glob (string)
               (format nil "~{~a~^.*~}"
                       (mapcar #'cl-ppcre:quote-meta-chars (str:split "*" string)))))
        (let ((wildcard (search "://*." pattern)))
          (str:concat "^"
                      (if wildcard
                          (str:concat (glob (subseq pattern 0 (+ wildcard 3)))
                                      "(?:[^/]*\\.)?"
                                      (glob (subseq pattern (+ wildcard 5))))
                          (glob pattern))
                      "$")))))

(defun %userscript-matches-p (metadata url)
  (flet ((patterns (&rest keys)
           (loop for (key . value) in metadata
                 when (member key keys :test #'string=)
                   collect value))
         (matches-any-p (patterns)
           (some (lambda (pattern)
                   (ignore-errors
                    (cl-ppcre:scan (%userscript-pattern-regex pattern) url)))
                 patterns)))
    (let ((includes (patterns "include" "match")))
      (and (or (null includes) (matches-any-p includes))
           (not (matches-any-p (patterns "exclude" "exclude-match")))))))

(defun %userscript-files ()
  (loop for directory in *userscript-directories*
        append (ignore-errors (uiop:directory* (merge-pathnames "*.user.js" directory)))))

(defun %userscript-wrap (name source)
  "SOURCE with the Greasemonkey calls most scripts use defined around it.

Only GM_addStyle and GM_info are provided; scripts that need storage or
cross-origin requests will not work."
  (format nil "(function () {
var unsafeWindow = window;
var GM_info = {script: {name: ~a}};
var GM_addStyle = function (css) {
  var style = document.createElement('style');
  style.textContent = css;
  (document.head || document.documentElement).appendChild(style);
  return style;
};
~a
})();"
          (cl-json:encode-json-to-string name)
          source))

(define-mode userscript-mode ()
  "Run matching *.user.js files from `*userscript-directories*' on every page.

Nyxt 4's `user-script-mode' is not implemented for the Electron renderer, so
this injects them itself once the page has loaded.  Scripts are re-read on each
load, so a new or edited script needs a reload, not a restart.  @run-at is
ignored: everything runs at document-idle."
  ((visible-in-status-p nil)))

(defmethod on-signal-load-finished ((mode userscript-mode) url title)
  (declare (ignore title))
  (let ((buffer (buffer mode))
        (url-string (quri:render-uri url)))
    (unless (internal-url-p url)
      (dolist (file (%userscript-files))
        (ignore-errors
         (let* ((source (alexandria:read-file-into-string file))
                (metadata (%userscript-metadata source)))
           (when (%userscript-matches-p metadata url-string)
             (ffi-buffer-evaluate-javascript-async
              buffer
              (%userscript-wrap (or (alexandria:assoc-value metadata "name" :test #'string=)
                                    (pathname-name file))
                                source))))))))
  url)

(define-command-global list-userscripts ()
  "Show which userscripts would run on the current page."
  (let ((url (quri:render-uri (url (current-buffer)))))
    (echo "~:[No userscripts~;~:*~{~a~^, ~}~] on ~a"
          (loop for file in (%userscript-files)
                for metadata = (ignore-errors
                                (%userscript-metadata (alexandria:read-file-into-string file)))
                when (%userscript-matches-p metadata url)
                  collect (pathname-name file))
          url)))

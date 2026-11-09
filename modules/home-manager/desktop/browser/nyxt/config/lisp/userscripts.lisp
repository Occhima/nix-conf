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

(defun %userscript-values (metadata &rest keys)
  (loop for (key . value) in metadata
        when (member key keys :test #'string=)
          collect value))

(defun %userscript-matches-p (metadata url)
  (flet ((patterns (&rest keys)
           (apply #'%userscript-values metadata keys))
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

(defun %userscript-wrap (metadata name source)
  "SOURCE with its @include/@exclude checked and Greasemonkey calls defined."
  (flet ((regexes (&rest keys)
           (cl-json:encode-json-to-string
            (or (mapcar #'%userscript-pattern-regex (apply #'%userscript-values metadata keys))
                #()))))
    (format nil "(function () {
var href = location.href;
var test = function (r) { try { return new RegExp(r).test(href); } catch (e) { return false; } };
var include = ~a, exclude = ~a;
if (include.length && !include.some(test)) return;
if (exclude.some(test)) return;
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
            (regexes "include" "match")
            (regexes "exclude" "exclude-match")
            (cl-json:encode-json-to-string name)
            (cl-ppcre:regex-replace "(?s)//\\s*==UserScript==.*?==/UserScript==" source ""))))

(defun %userscript (file)
  "FILE as a `user-script', or NIL when it cannot be read."
  (ignore-errors
   (let* ((source (alexandria:read-file-into-string file))
          (metadata (%userscript-metadata source))
          (script (make-instance 'nyxt/mode/user-script:user-script
                                 :code (%userscript-wrap
                                        metadata
                                        (or (alexandria:assoc-value metadata "name" :test #'string=)
                                            (pathname-name file))
                                        source))))
     (setf (nyxt/mode/user-script:run-at script)
           (alexandria:switch ((alexandria:assoc-value metadata "run-at" :test #'string=)
                                :test #'equal)
             ("document-start" :document-start)
             ("document-idle" :document-idle)
             (t :document-end))
           (nyxt/mode/user-script:all-frames-p script)
           (not (assoc "noframes" metadata :test #'string=)))
     script)))

(defun %userscripts ()
  (remove nil (mapcar #'%userscript (%userscript-files))))

(define-configuration nyxt/mode/user-script:user-script-mode
  ((nyxt/mode/user-script:user-scripts (%userscripts))
   (visible-in-status-p nil)))

(define-command-global reload-userscripts ()
  "Re-read `*userscript-directories*' into every buffer; edits apply from the next load."
  (dolist (buffer (buffer-list))
    (alexandria:when-let ((mode (find-submode 'nyxt/mode/user-script:user-script-mode buffer)))
      (setf (nyxt/mode/user-script:user-scripts mode) (%userscripts))))
  (echo "Reloaded ~a userscripts" (length (%userscript-files))))

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

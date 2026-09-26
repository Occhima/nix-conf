(in-package #:nyxt-user)

(defun %readability-article (buffer)
  "Readability's parse of BUFFER as an alist (:title :byline :content ...), or NIL."
  (let ((json (ignore-errors
               (ffi-buffer-evaluate-javascript
                buffer
                (str:concat (alexandria:read-file-into-string *readability-js*)
                            ";(() => { const a = new Readability(document.cloneNode(true)).parse();"
                            " return a ? JSON.stringify(a) : ''; })()")))))
    (when (and (stringp json) (plusp (length json)))
      (cl-json:decode-json-from-string json))))

(defun %reader-css ()
  (theme:themed-css (theme *browser*)
    `(body
      :background-color ,theme:background-color
      :color ,theme:on-background-color
      :font-family ,(%sans-stack theme:font-family)
      :font-size "18px"
      :line-height "1.7"
      :margin "0"
      :padding "48px 24px 96px")
    '(article
      :max-width "42rem"
      :margin "0 auto")
    `(h1
      :font-size "2em"
      :line-height "1.2"
      :letter-spacing "-0.015em"
      :margin "0 0 0.3em")
    `(".byline"
      :color ,theme:primary-color
      :font-size "0.85em"
      :margin "0 0 2.5em")
    `(a
      :color ,theme:on-background-color
      :text-decoration "none"
      :border-bottom ,(format nil "1px solid ~a" (%hairline theme:on-background-color 0.30)))
    '("img, video, figure"
      :max-width "100%"
      :height "auto")
    `("pre, code"
      :font-family ,(%mono-stack theme:monospace-font-family)
      :font-size "0.85em")
    `(pre
      :background-color ,theme:background-color+
      :padding "14px 16px"
      :border-radius "8px"
      :overflow-x "auto")
    `(blockquote
      :margin "1.2em 0"
      :padding-left "16px"
      :border-left ,(format nil "2px solid ~a" (%hairline theme:on-background-color 0.25))
      :color ,theme:primary-color)))

(define-command reader-mode (&optional (buffer (current-buffer)))
  "Show the current page as a clean article; reload to get the page back."
  (alexandria:if-let ((article (%readability-article buffer)))
    (let ((html (spinneret:with-html-string
                  (:head (:style (:raw (%reader-css))))
                  (:body
                   (:article
                    (:h1 (alexandria:assoc-value article :title))
                    (alexandria:when-let ((byline (alexandria:assoc-value article :byline)))
                      (:p.byline byline))
                    (:raw (alexandria:assoc-value article :content)))))))
      (ps-eval :buffer buffer
        (setf (ps:chain document document-element inner-h-t-m-l) (ps:lisp html))
        nil))
    (echo-warning "No article found on this page.")))

(define-command save-article-to-roam (&optional (buffer (current-buffer)))
  "Convert the current page's article to Org and file it as an org-roam node."
  (alexandria:if-let ((article (%readability-article buffer)))
    (let ((file (format nil "~anyxt-article-~a.org"
                        (uiop:native-namestring (uiop:temporary-directory))
                        (get-universal-time))))
      (uiop:run-program (list *pandoc* "-f" "html" "-t" "org" "--wrap=none" "-o" file)
                        :input (make-string-input-stream
                                (alexandria:assoc-value article :content)))
      (%emacs-eval "(occhima/nyxt-roam-import ~s ~s ~s)"
                   file
                   (render-url (url buffer))
                   (or (alexandria:assoc-value article :title) (title buffer)))
      (echo "Saving to org-roam: ~a" (title buffer)))
    (echo-warning "No article found on this page.")))

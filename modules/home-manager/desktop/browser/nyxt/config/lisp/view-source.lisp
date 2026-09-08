(in-package #:nyxt-user)

;; Themed, pretty-printed view-source.  Overrides upstream's handler, which
;; serves raw text/plain and leaves rendering to Chromium's white plain-text
;; viewer.  Callbacks in `nyxt::*schemes*' are read when the browser registers
;; custom schemes at startup, which happens after config load, so this wins.

(defparameter %void-elements
  '("area" "base" "br" "col" "embed" "hr" "img" "input" "link" "meta" "param"
    "source" "track" "wbr")
  "HTML elements that never take a closing tag.")

(defun %source-escape (string)
  "HTML-escape STRING for safe embedding."
  (with-output-to-string (out)
    (loop for char across string
          do (case char
               (#\& (write-string "&amp;" out))
               (#\< (write-string "&lt;" out))
               (#\> (write-string "&gt;" out))
               (#\" (write-string "&quot;" out))
               (t (write-char char out)))))))

(defun %source-attrs (element)
  "Render ELEMENT's attributes as highlighted markup."
  (with-output-to-string (out)
    (maphash (lambda (name value)
               (format out " <span class=\"attr\">~a</span>=<span class=\"val\">\"~a\"</span>"
                       (%source-escape name)
                       (%source-escape (or value ""))))
             (plump:attributes element))))

(defun %source-open-tag (element)
  (format nil "<span class=\"tag\">&lt;~a~a&gt;</span>"
          (plump:tag-name element)
          (%source-attrs element)))

(defun %source-close-tag (element)
  (format nil "<span class=\"tag\">&lt;/~a&gt;</span>" (plump:tag-name element)))

(defun %source-serialize (node out)
  "Serialize plump NODE as themed, indented markup.
Indentation comes from nested .node divs (see CSS), not spaces."
  (typecase node
    (plump:comment
     (format out "<div class=\"node\"><span class=\"comment\">&lt;!-- ~a --&gt;</span></div>"
             (%source-escape (plump:text node))))
    (plump:text-node
     (unless (str:blankp (plump:text node))
       (format out "<div class=\"node\"><span class=\"text\">~a</span></div>"
               (%source-escape (plump:text node)))))
    (plump:element
     (let* ((children (coerce (plump:children node) 'list))
            (fulltext-p (typep node 'plump:fulltext-element))
            ;; ponytail: single text child inlines on one line; real
            ;; syntax-highlighting can come later if wanted.
            (inline-p (and (not fulltext-p)
                           (= 1 (length children))
                           (typep (first children) 'plump:text-node)
                           (not (str:blankp (plump:text (first children))))))
            (void-p (member (plump:tag-name node) %void-elements :test #'string=)))
       (format out "<div class=\"node\">~a" (%source-open-tag node))
       (cond ((or void-p (not children)))
             ((or inline-p fulltext-p)
              (format out "<span class=\"text\">~a</span>~a"
                      (%source-escape (plump:text (first children)))
                      (unless void-p (%source-close-tag node))))
             (t
              (dolist (child children) (%source-serialize child out))
              (format out "~a" (%source-close-tag node))))
       (write-string "</div>" out)))))

(defun %source-css ()
  (theme:themed-css (theme *browser*)
    `(html :background-color ,theme:background-color)
    `(body :margin "0"
           :background-color ,theme:background-color
           :color ,theme:primary-color
           :font-family ,(%mono-stack theme:monospace-font-family)
           :font-size "12.5px"
           :line-height "1.6")
    `(header :position "sticky"
             :top "0"
             :padding "6px 14px"
             :background-color ,theme:background-color
             :color ,(%hairline theme:primary-color 0.45)
             :border-bottom ,(format nil "1px solid ~a" (%hairline theme:primary-color 0.15)))
    `(.node :padding-left "1.5ch"
            :white-space "pre-wrap"
            :word-break "break-all")
    `(main :padding "10px 8px 40px 6px")
    `(.tag :color ,theme:secondary-color)
    `(.attr :color ,theme:tertiary-color)
    `(.val :color ,theme:highlight-color)
    `(.text :color ,theme:primary-color)
    `(.comment :color ,(%hairline theme:primary-color 0.55))))

(defun %source-page (url source)
  "Full HTML page for the source of URL."
  (spinneret:with-html-string
    (:html
     (:head (:title (format nil "view-source:~a" url))
            (:style (%source-css)))
     (:body
      (:header (:code (format nil "view-source:~a" url)))
      (:main
       (if source
           (:raw (with-output-to-string (out)
                   (dolist (child (coerce (plump:children (plump:parse source)) 'list))
                     (%source-serialize child out))))
           (:p "No buffer loaded this URL; load the page, then view its source.")))))))

(define-internal-scheme "view-source"
  (lambda (url)
    (let ((source-url (quri:uri-path (quri:uri url))))
      (values (%source-page source-url (ignore-errors (get-url-source source-url)))
              "text/html; charset=utf-8")))
  (lambda (condition)
    (values (format nil "<p>view-source failed: ~a</p>" condition)
            "text/html; charset=utf-8")))

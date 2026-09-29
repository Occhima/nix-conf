(in-package #:nyxt-user)

(defvar *tracking-parameters*
  '("fbclid" "gclid" "dclid" "gbraid" "wbraid" "msclkid" "yclid" "igshid"
    "mc_cid" "mc_eid" "_hsenc" "_hsmi" "ref_src" "ref_url" "spm")
  "Query parameters dropped from copied URLs, besides every utm_* one.

`reduce-tracking-mode' is not implemented for the Electron renderer, so
this is where tracking parameters get stripped.")

(defun %tracking-parameter-p (name)
  (or (str:starts-with-p "utm_" name :ignore-case t)
      (member name *tracking-parameters* :test #'string-equal)))

(defun clean-url (url)
  "URL, a string or `quri:uri', as a string without tracking parameters."
  (let* ((uri (quri:copy-uri (quri:uri url)))
         (params (ignore-errors (quri:uri-query-params uri)))
         (kept (remove-if (lambda (param) (%tracking-parameter-p (car param))) params)))
    ;; Re-encoding untouched queries could change them, so only rewrite on removal.
    (unless (= (length kept) (length params))
      (setf (quri:uri-query uri)
            (when kept (quri:url-encode-params kept))))
    (quri:render-uri uri)))

(defun %link-title (url title)
  (str:collapse-whitespaces (if (str:blankp title) (clean-url url) title)))

(defun org-link (url title)
  (format nil "[[~a][~a]]"
          (clean-url url)
          (substitute #\) #\] (substitute #\( #\[ (%link-title url title)))))

(defun markdown-link (url title)
  (format nil "[~a](~a)"
          (str:replace-using '("[" "\\[" "]" "\\]") (%link-title url title))
          (str:replace-using '("(" "%28" ")" "%29") (clean-url url))))

(defun %copy (text)
  (copy-to-clipboard text)
  (echo "Copied ~a" text))

(define-command-global copy-clean-url (&optional (buffer (current-buffer)))
  "Copy the current URL without tracking parameters."
  (%copy (clean-url (url buffer))))

(define-command-global copy-org-link (&optional (buffer (current-buffer)))
  "Copy the current page as an Org link."
  (%copy (org-link (url buffer) (title buffer))))

(define-command-global copy-markdown-link (&optional (buffer (current-buffer)))
  "Copy the current page as a Markdown link."
  (%copy (markdown-link (url buffer) (title buffer))))

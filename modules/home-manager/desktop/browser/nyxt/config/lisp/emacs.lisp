(in-package #:nyxt-user)

(defun %emacs-eval (control &rest args)
  "Evaluate a `format'ted form in the running Emacs daemon, asynchronously."
  (uiop:launch-program
   (list "emacsclient" "--eval" (apply #'format nil control args))
   :output nil
   :error-output nil))

(defun %current-url-string ()
  (render-url (url (current-buffer))))

(defun %selection (&optional (buffer (current-buffer)))
  (or (ignore-errors
       (ps-eval :buffer buffer (ps:chain window (get-selection) (to-string))))
      ""))

(define-command capture-in-org-roam ()
  "Capture the current page, with any selected text as a quote, as an org-roam node."
  (%emacs-eval "(occhima/nyxt-roam-capture ~s ~s ~s)"
               (%current-url-string)
               (title (current-buffer))
               (%selection))
  (echo "Capturing in org-roam: ~a" (title (current-buffer))))

(define-command read-later ()
  "Schedule the current page in the Org agenda's reading list."
  (%emacs-eval "(occhima/nyxt-read-later ~s ~s)"
               (%current-url-string)
               (title (current-buffer)))
  (echo "Read later: ~a" (title (current-buffer))))

(defun %arxiv-id (url)
  (alexandria:when-let ((host (quri:uri-host (quri:uri url))))
    (when (search "arxiv" host :test #'char-equal)
      (values (cl-ppcre:scan-to-strings "\\d{4}\\.\\d{4,5}" url)))))

(defparameter *doi-regex* "10\\.\\d{4,9}/[^\\s\"'<>?#]+")

(defun %clean-doi (doi)
  (string-right-trim ".,;)" doi))

(defun %url-doi (url)
  "DOI embedded in URL, percent-decoded, or NIL."
  (let ((string (quri:render-uri (quri:uri url))))
    (alexandria:when-let
        ((doi (cl-ppcre:scan-to-strings *doi-regex*
                                        (or (ignore-errors (quri:url-decode string)) string))))
      (%clean-doi doi))))

(defun %page-doi (&optional (buffer (current-buffer)))
  "DOI from the page's citation metadata, else from its URL."
  (let ((meta (or (ignore-errors
                   (ps-eval :buffer buffer
                     (let ((tag (ps:chain document
                                          (query-selector
                                           "meta[name='citation_doi'],meta[name='dc.identifier' i],meta[name='prism.doi']"))))
                       (if tag (ps:@ tag content) ""))))
                  "")))
    (or (alexandria:when-let ((doi (cl-ppcre:scan-to-strings *doi-regex* meta)))
          (%clean-doi doi))
        (%url-doi (url buffer)))))

(defun add-paper-from-url (url &optional doi)
  "Add the paper at URL to the bibliography by arXiv id, else DOI, else warn."
  (let ((url-string (quri:render-uri (quri:uri url))))
    (alexandria:if-let ((id (%arxiv-id url-string)))
      (progn
        (%emacs-eval "(occhima/nyxt-arxiv-add ~s)" id)
        (echo "Adding arXiv:~a to the library" id))
      (alexandria:if-let ((doi (or doi (%url-doi url))))
        (progn
          (%emacs-eval "(occhima/nyxt-doi-add ~s)" doi)
          (echo "Adding doi:~a to the library" doi))
        (echo-warning "No arXiv id or DOI on ~a" url-string)))))

(define-command add-paper ()
  "Add the paper on the current page to the bibliography, by arXiv id or DOI."
  (add-paper-from-url (url (current-buffer))
                      (unless (%arxiv-id (%current-url-string)) (%page-doi))))

(define-command open-in-emacs ()
  "Open the current URL in Emacs's eww.

Not `browse-url': both Emacs configurations point that back at Nyxt."
  (%emacs-eval "(eww ~s)" (%current-url-string))
  (echo "Opening in eww"))

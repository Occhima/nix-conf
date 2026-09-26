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

(defun %page-doi (&optional (buffer (current-buffer)))
  "DOI from the page's citation metadata, else from its URL."
  (let ((meta (or (ignore-errors
                   (ps-eval :buffer buffer
                     (let ((tag (ps:chain document
                                          (query-selector
                                           "meta[name='citation_doi'],meta[name='dc.identifier' i],meta[name='prism.doi']"))))
                       (if tag (ps:@ tag content) ""))))
                  "")))
    (alexandria:when-let
        ((doi (cl-ppcre:scan-to-strings "10\\.\\d{4,9}/[^\\s\"'<>?#]+"
                                        (str:concat meta " " (render-url (url buffer))))))
      (string-right-trim ".,;)" doi))))

(define-command add-paper ()
  "Add the paper on the current page to the bibliography, by arXiv id or DOI."
  (let ((url (%current-url-string)))
    (alexandria:if-let ((id (%arxiv-id url)))
      (progn
        (%emacs-eval "(occhima/nyxt-arxiv-add ~s)" id)
        (echo "Adding arXiv:~a to the library" id))
      (alexandria:if-let ((doi (%page-doi)))
        (progn
          (%emacs-eval "(occhima/nyxt-doi-add ~s)" doi)
          (echo "Adding doi:~a to the library" doi))
        (echo-warning "No arXiv id or DOI on ~a" url)))))

(define-command open-in-emacs ()
  "Open the current URL inside Emacs with `browse-url'."
  (%emacs-eval "(browse-url ~s)" (%current-url-string))
  (echo "Opening in Emacs"))

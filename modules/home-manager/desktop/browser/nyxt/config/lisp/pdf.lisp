(in-package #:nyxt-user)

(defvar *pdf-directory*
  (merge-pathnames "nyxt/pdf/" (uiop:xdg-cache-home))
  "Where PDFs handed to Emacs are downloaded.")

(defun pdf-url-p (url)
  "Whether URL looks like a PDF: a .pdf path, or an arXiv /pdf/ link."
  (let* ((uri (quri:uri (or url "")))
         (path (or (quri:uri-path uri) "")))
    (or (str:ends-with-p ".pdf" path :ignore-case t)
        (and (search "arxiv.org" (or (quri:uri-host uri) "") :test #'char-equal)
             (str:starts-with-p "/pdf/" path)))))

(defun %pdf-file (url)
  (let* ((segment (alexandria:lastcar
                   (str:split "/" (or (quri:uri-path (quri:uri url)) "") :omit-nulls t)))
         (name (substitute #\_ #\/ (or (ignore-errors (quri:url-decode segment)) "document"))))
    (merge-pathnames (uiop:parse-native-namestring
                      (if (str:ends-with-p ".pdf" name :ignore-case t)
                          name
                          (str:concat name ".pdf")))
                     *pdf-directory*)))

(defun open-pdf-in-emacs (url)
  "Download URL in the background, then open it in a new Emacs frame."
  (let ((url-string (quri:render-uri (quri:uri url)))
        (file (%pdf-file url)))
    (echo "Downloading ~a for Emacs" (file-namestring file))
    (run-thread "pdf to emacs"
      (handler-case
          (let ((bytes (dexador:get url-string :force-binary t
                                               :connect-timeout 10 :read-timeout 60)))
            (ensure-directories-exist file)
            (alexandria:write-byte-vector-into-file bytes file :if-exists :supersede)
            (uiop:launch-program (list "emacsclient" "-c" "-n" (uiop:native-namestring file))
                                 :output nil :error-output nil)
            (echo "Opened ~a in Emacs" (file-namestring file)))
        (error (condition)
          (echo-warning "Could not fetch ~a: ~a" url-string condition))))))

(define-command-global open-pdf-in-emacs-current (&optional (buffer (current-buffer)))
  "Open the current page, a PDF, in Emacs."
  (open-pdf-in-emacs (url buffer)))

(defmethod nyxt/mode/hint::%follow-hint :around ((a nyxt/dom:a-element))
  "Hand PDF links to Emacs; Electron has no PDF viewer to follow them into."
  (if (pdf-url-p (url a))
      (open-pdf-in-emacs (url a))
      (call-next-method)))

(defmethod nyxt/mode/hint::%follow-hint-new-buffer :around ((a nyxt/dom:a-element))
  (if (pdf-url-p (url a))
      (open-pdf-in-emacs (url a))
      (call-next-method)))

(defmethod nyxt/mode/hint::%follow-hint-new-buffer-focus :around ((a nyxt/dom:a-element))
  (if (pdf-url-p (url a))
      (open-pdf-in-emacs (url a))
      (call-next-method)))

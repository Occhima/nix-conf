(in-package #:nyxt-user)

(defun url-up (url)
  "URL one path level up, query and fragment dropped, or NIL at the root."
  (let* ((uri (quri:copy-uri (quri:uri url)))
         (segments (str:split "/" (or (quri:uri-path uri) "") :omit-nulls t)))
    (when (or segments (quri:uri-query uri) (quri:uri-fragment uri))
      (setf (quri:uri-path uri) (format nil "/~{~a/~}" (butlast segments))
            (quri:uri-query uri) nil
            (quri:uri-fragment uri) nil)
      uri)))

(defun url-root (url)
  (let ((uri (quri:copy-uri (quri:uri url))))
    (setf (quri:uri-path uri) "/"
          (quri:uri-query uri) nil
          (quri:uri-fragment uri) nil)
    uri))

(defun url-increment (url delta)
  "URL with the last number of its path or query moved by DELTA, or NIL.

Zero padding is kept, so page-009 becomes page-010.  The host is never
touched, which keeps numbers in domain names out of it."
  (let* ((uri (quri:uri url))
         (tail (format nil "~@[~a~]~@[?~a~]" (quri:uri-path uri) (quri:uri-query uri)))
         (last-start nil)
         (last-end nil))
    (cl-ppcre:do-matches (start end "\\d+" tail)
      (setf last-start start last-end end))
    (when last-start
      (let* ((digits (subseq tail last-start last-end))
             (number (max 0 (+ (parse-integer digits) delta)))
             (width (if (char= #\0 (char digits 0)) (length digits) 0))
             (new-tail (str:concat (subseq tail 0 last-start)
                                   (format nil "~v,'0d" width number)
                                   (subseq tail last-end)))
             (query-start (position #\? new-tail))
             (copy (quri:copy-uri uri)))
        (setf (quri:uri-path copy) (subseq new-tail 0 query-start)
              (quri:uri-query copy) (when query-start (subseq new-tail (1+ query-start)))
              (quri:uri-fragment copy) nil)
        copy))))

(defun %navigate (buffer url message)
  (if url
      (ffi-buffer-load buffer url)
      (echo-warning message)))

(define-command-global go-up (&optional (buffer (current-buffer)))
  "Go one level up the URL path."
  (%navigate buffer (url-up (url buffer)) "Already at the root."))

(define-command-global go-root (&optional (buffer (current-buffer)))
  "Go to the root of the current site."
  (%navigate buffer (url-root (url buffer)) "Already at the root."))

(define-command-global increment-url (&optional (buffer (current-buffer)))
  "Increment the last number in the URL, as for the next page of a listing."
  (%navigate buffer (url-increment (url buffer) 1) "No number in this URL."))

(define-command-global decrement-url (&optional (buffer (current-buffer)))
  "Decrement the last number in the URL."
  (%navigate buffer (url-increment (url buffer) -1) "No number in this URL."))

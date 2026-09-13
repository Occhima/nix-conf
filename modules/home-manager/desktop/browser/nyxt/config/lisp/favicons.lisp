(in-package #:nyxt-user)

;; Favicon pipeline shared by the internal pages: every domain is fetched at
;; most once per retry window, cached on disk, and inlined as a data: URI.
;; Split out of start-page.lisp so the cache stays independent of what any
;; one page renders.

(defvar *favicon-cache-dir*
  (uiop:ensure-directory-pathname
   (uiop:parse-native-namestring
    (format nil "~a/nyxt/favicons"
            (or (uiop:getenv "XDG_CACHE_HOME")
                (format nil "~a/.cache" (uiop:getenv "HOME"))))))
  "Where fetched favicons are cached, one file per domain, kept forever.")

(defvar *favicon-attempted* (make-hash-table :test 'equal)
  "Domain -> UNIVERSAL-TIME of the last fetch attempt, successful or not.

Recorded even on failure so a domain whose icon 404s is not retried, and the
start page re-rendered, on every single load.")

(defvar *favicon-retry-ttl* 86400
  "Seconds before a failed favicon fetch is retried.")

(defvar *favicon-uris* (make-hash-table :test 'equal)
  "Domain -> data: URI, so a cached icon is read and encoded once per session.")

(defvar *base64-alphabet*
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")

(defun %base64 (bytes)
  "BYTES as a base64 string.

Spelled out rather than taken from a library because the image of the binary
release is fixed and nothing guarantees a base64 system was built into it."
  (let ((length (length bytes))
        (out (make-string-output-stream)))
    (loop for index from 0 below length by 3
          for remaining = (- length index)
          for triple = (logior (ash (aref bytes index) 16)
                               (ash (if (> remaining 1) (aref bytes (+ index 1)) 0) 8)
                               (if (> remaining 2) (aref bytes (+ index 2)) 0))
          do (write-char (char *base64-alphabet* (ldb (byte 6 18) triple)) out)
             (write-char (char *base64-alphabet* (ldb (byte 6 12) triple)) out)
             (write-char (if (> remaining 1)
                             (char *base64-alphabet* (ldb (byte 6 6) triple))
                             #\=)
                         out)
             (write-char (if (> remaining 2)
                             (char *base64-alphabet* (ldb (byte 6 0) triple))
                             #\=)
                         out))
    (get-output-stream-string out)))

(defun %favicon-file-name (domain)
  "DOMAIN as a flat file name, a domain not being guaranteed path-safe."
  (substitute-if #\_
                 (lambda (character)
                   (not (or (alphanumericp character)
                            (member character '(#\. #\-)))))
                 domain))

(defun %favicon-path (domain)
  (merge-pathnames (format nil "~a.ico" (%favicon-file-name domain))
                   *favicon-cache-dir*))

(defun %favicon-stale-attempt-p (domain)
  "Whether DOMAIN's icon is worth requesting again."
  (alexandria:if-let ((at (gethash domain *favicon-attempted*)))
    (> (- (get-universal-time) at) *favicon-retry-ttl*)
    t))

(defun %favicon-fetch (domain)
  "Cache DOMAIN's favicon to disk via DuckDuckGo's icon proxy.

Only DOMAIN is sent, not the page URL, and the icon is kept locally after
that so a repeat visit costs no request at all.  The attempt is recorded
before the request rather than after it, so that a domain serving no icon
is retried on a timer instead of on every render."
  (let ((path (%favicon-path domain)))
    (setf (gethash domain *favicon-attempted*) (get-universal-time))
    (ignore-errors
     (let ((bytes (dexador:get (format nil "https://icons.duckduckgo.com/ip3/~a.ico" domain)
                               :connect-timeout 3 :read-timeout 5 :force-binary t)))
       (when (and (typep bytes '(vector (unsigned-byte 8))) (plusp (length bytes)))
         (ensure-directories-exist *favicon-cache-dir*)
         (with-open-file (stream path :direction :output
                                      :element-type '(unsigned-byte 8)
                                      :if-exists :supersede)
           (write-sequence bytes stream))
         path)))))

(defun %image-content-type (bytes)
  "MIME type of BYTES, which the icon proxy serves as either PNG or ICO."
  (if (and (>= (length bytes) 4)
           (equalp (subseq bytes 0 4) #(137 80 78 71)))
      "image/png"
      "image/x-icon"))

(defun %favicon-uri (domain)
  "DOMAIN's cached icon as a data: URI, or NIL while it is not cached.

Internal pages are served over the `nyxt:' scheme and Chromium refuses a
`file://' subresource from any other origin, so the bytes travel inline.
Only a hit is memoised: a miss has to stay a miss no longer than it takes
the icon to land."
  (when domain
    (or (gethash domain *favicon-uris*)
        (alexandria:when-let
            ((uri (ignore-errors
                   (alexandria:when-let ((path (probe-file (%favicon-path domain))))
                     (let ((bytes (alexandria:read-file-into-byte-vector path)))
                       (format nil "data:~a;base64,~a"
                               (%image-content-type bytes) (%base64 bytes)))))))
          (setf (gethash domain *favicon-uris*) uri)))))

(defun %favicon-html (domain)
  "Cached favicon <img>, or a letter-avatar fallback while it is unavailable."
  (spinneret:with-html
    (alexandria:if-let ((uri (%favicon-uri domain)))
      (:img :class "favicon" :src uri :alt "")
      (:span :class "favicon favicon-fallback"
             (if (str:emptyp (or domain "")) "?" (string-upcase (subseq domain 0 1)))))))

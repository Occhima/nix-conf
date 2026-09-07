(in-package #:nyxt-user)

(defvar *mirrors*
  '(("youtube.com" . "yewtu.be")
    ("www.youtube.com" . "yewtu.be")
    ("m.youtube.com" . "yewtu.be")
    ("youtu.be" . "yewtu.be")
    ("reddit.com" . "old.reddit.com")
    ("www.reddit.com" . "old.reddit.com"))
  "Alist mapping an upstream host to the front-end to use instead.

The front-ends match the ones already used by *EXTRA-SEARCH-ENGINES*.")

(defun %mirror-url (url)
  "URL with its host swapped for a front-end, or NIL when none applies."
  (alexandria:when-let* ((host (quri:uri-host url))
                         (mirror (alexandria:assoc-value *mirrors* host
                                                         :test #'string-equal)))
    (let ((mirrored (quri:copy-uri url)))
      (setf (quri:uri-host mirrored) mirror)
      mirrored)))

(define-mode mirror-mode ()
  "Send mainstream sites to privacy-preserving front-ends.

The Electron renderer never runs `request-resource-hook', so redirects cannot
happen before the request leaves.  `on-signal-load-started' is the earliest
point Nyxt exposes here, so the original page starts loading and is navigated
away from immediately."
  ((visible-in-status-p nil)))

(defmethod on-signal-load-started ((mode mirror-mode) url)
  (alexandria:when-let ((target (%mirror-url url)))
    (ffi-buffer-load (buffer mode) target))
  url)

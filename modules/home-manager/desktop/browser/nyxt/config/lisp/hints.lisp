(in-package #:nyxt-user)

(defvar *mpv* "mpv"
  "mpv executable; paths.lisp points it at the Nix store.")

(defun %hint-links (prompt function &key (multiple t))
  "Hint links, then call FUNCTION on each chosen link's URL and text.

With MULTIPLE, several links can be marked; FUNCTION then gets all of them
as one list of (URL . TEXT), which is what a playlist or a batch wants."
  (nyxt/mode/hint:query-hints
   prompt
   (lambda (elements)
     (let ((links (loop for element in elements
                        for url = (ignore-errors (url element))
                        when url
                          collect (cons url (str:collapse-whitespaces
                                             (or (ignore-errors (nyxt/dom:body element)) ""))))))
       (if links
           (funcall function links)
           (echo-warning "No link selected."))))
   :enable-marks-p multiple
   :selector "a[href]"))

(defun play-in-mpv (urls)
  (uiop:launch-program (cons *mpv* (mapcar #'quri:render-uri urls))
                       :output nil :error-output nil)
  (echo "Playing ~a in mpv" (if (rest urls)
                                (format nil "~a links" (length urls))
                                (quri:render-uri (first urls)))))

(define-command-global play-in-mpv-current (&optional (buffer (current-buffer)))
  "Play the current page in mpv."
  (play-in-mpv (list (url buffer))))

(define-command-global hint-play-in-mpv ()
  "Play hinted links in mpv, several as one playlist."
  (%hint-links "Play in mpv" (lambda (links) (play-in-mpv (mapcar #'car links)))))

(define-command-global hint-open-in-emacs ()
  "Open a hinted link in Emacs's eww."
  (%hint-links "Open in eww"
               (lambda (links)
                 (%emacs-eval "(eww ~s)" (quri:render-uri (car (first links))))
                 (echo "Opening in eww"))
               :multiple nil))

(define-command-global hint-capture-in-org-roam ()
  "Capture a hinted link as an org-roam node, titled by its text."
  (%hint-links "Capture in org-roam"
               (lambda (links)
                 (destructuring-bind (url . text) (first links)
                   (%emacs-eval "(occhima/nyxt-roam-capture ~s ~s ~s)"
                                (clean-url url)
                                (if (str:blankp text) (clean-url url) text)
                                "")
                   (echo "Capturing in org-roam: ~a" text)))
               :multiple nil))

(define-command-global hint-add-paper ()
  "Add hinted arXiv or DOI links to the bibliography."
  (%hint-links "Add paper"
               (lambda (links)
                 (dolist (link links)
                   (add-paper-from-url (car link))))))

(define-command-global hint-copy-org-link ()
  "Copy a hinted link as an Org link, titled by its text."
  (%hint-links "Copy Org link"
               (lambda (links)
                 (destructuring-bind (url . text) (first links)
                   (%copy (org-link url text))))
               :multiple nil))

(define-command-global hint-copy-clean-url ()
  "Copy a hinted link's URL without tracking parameters."
  (%hint-links "Copy clean URL"
               (lambda (links) (%copy (clean-url (car (first links)))))
               :multiple nil))

(define-command-global hint-open-pdf-in-emacs ()
  "Download hinted links and open them in Emacs, whatever their URL looks like."
  (%hint-links "Open PDF in Emacs"
               (lambda (links)
                 (dolist (link links)
                   (open-pdf-in-emacs (car link))))))

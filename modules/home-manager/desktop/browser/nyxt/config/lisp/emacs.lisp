(in-package #:nyxt-user)

(defun %emacs-eval (control &rest args)
  "Evaluate a form in the running Emacs daemon, asynchronously.

CONTROL and ARGS are passed to `format'; use ~s for anything that must reach
Emacs as a string literal.  The elisp entry points live in the Doom config's
+academic.el, so the coupling between the two sides stays in one place."
  (uiop:launch-program
   (list "emacsclient" "--eval" (apply #'format nil control args))
   :output nil
   :error-output nil))

(defun %current-url-string ()
  (render-url (url (current-buffer))))

(define-command capture-in-org-roam ()
  "Capture the current page as an org-roam reference node."
  (%emacs-eval "(occhima/nyxt-roam-capture ~s ~s)"
               (%current-url-string)
               (title (current-buffer)))
  (echo "Capturing in org-roam: ~a" (title (current-buffer))))

(define-command add-arxiv-paper ()
  "Add the arXiv paper shown in the current buffer to the bibliography."
  (let ((url (%current-url-string)))
    (alexandria:if-let
        ((id (aref (nth-value 1 (cl-ppcre:scan-to-strings
                                 "(\\d{4}\\.\\d{4,5})" url))
                   0)))
      (progn
        (%emacs-eval "(occhima/nyxt-arxiv-add ~s)" id)
        (echo "Adding arXiv:~a to the library" id))
      (echo-warning "No arXiv identifier in ~a" url))))

(define-command open-in-emacs ()
  "Open the current URL inside Emacs with `browse-url'."
  (%emacs-eval "(browse-url ~s)" (%current-url-string))
  (echo "Opening in Emacs"))

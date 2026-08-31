;;; +nyxt.el -*- lexical-binding: t; -*-

(defvar occhima/nyxt-slynk-port 4008
  "Port that Nyxt's `start-slynk' command listens on.")

(setq! browse-url-browser-function #'browse-url-generic
       browse-url-generic-program "nyxt")

(after! sly
  (setq sly-contribs (delq 'sly-quicklisp sly-contribs)))

(defun occhima/nyxt-connect ()
  "Connect SLY to Nyxt's Slynk server.

Run `start-slynk' inside Nyxt first; it is a command rather than a startup
action because it exposes evaluation into the browser image."
  (interactive)
  (sly-connect "127.0.0.1" occhima/nyxt-slynk-port))

(defun occhima/nyxt-eval (form)
  "Evaluate FORM, a Common Lisp source string, inside the connected Nyxt."
  (unless (sly-connected-p)
    (occhima/nyxt-connect))
  (sly-eval `(slynk:interactive-eval-region ,form)))

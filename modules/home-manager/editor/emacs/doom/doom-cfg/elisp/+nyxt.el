;;; +nyxt.el -*- lexical-binding: t; -*-

(defvar occhima/nyxt-slynk-port 4008
  "Port that Nyxt's `start-slynk' command listens on.")

(setq! browse-url-browser-function #'occhima/nyxt-browse-url)

(after! sly
  (setq sly-contribs (delq 'sly-quicklisp sly-contribs)))

(defun occhima/nyxt-connect ()
  "Connect SLY to Nyxt's Slynk server.

Run `start-slynk' inside Nyxt first; it is a command rather than a startup
action because it exposes evaluation into the browser image."
  (interactive)
  (sly-connect "127.0.0.1" occhima/nyxt-slynk-port))

(defun occhima/nyxt-socket ()
  "Socket the running Nyxt listens on."
  (expand-file-name "nyxt/nyxt.socket"
                    (or (getenv "XDG_RUNTIME_DIR")
                        (format "/run/user/%d" (user-uid)))))

(defun occhima/nyxt-eval (form)
  "Evaluate FORM, a Common Lisp source string, in the running Nyxt."
  (let ((process (make-network-process :name "nyxt-eval"
                                       :family 'local
                                       :service (occhima/nyxt-socket)
                                       :noquery t)))
    (process-send-string process form)
    (process-send-eof process)))

(defun occhima/nyxt-browse-url (url &rest _)
  "Open URL in the running Nyxt, starting one when none answers on the socket."
  (condition-case nil
      (occhima/nyxt-eval (format "(open-urls %S)" url))
    (file-error (start-process "nyxt" nil "nyxt" url))))

(defvar occhima/nyxt--insert-marker nil
  "Where `occhima/nyxt-insert-link' puts the link Nyxt sends back.")

(defun occhima/nyxt-insert-current-link ()
  "Insert a link to the page open in Nyxt at point."
  (interactive)
  (setq occhima/nyxt--insert-marker (point-marker))
  (occhima/nyxt-eval "(emacs-insert-current-link)"))

(defun occhima/nyxt-insert-link (url title)
  "Insert URL with TITLE at `occhima/nyxt--insert-marker'. Called by Nyxt."
  (when-let* ((marker occhima/nyxt--insert-marker)
              ((buffer-live-p (marker-buffer marker))))
    (with-current-buffer (marker-buffer marker)
      (save-excursion
        (goto-char marker)
        (insert (cond ((derived-mode-p 'org-mode) (org-link-make-string url title))
                      ((derived-mode-p 'markdown-mode) (format "[%s](%s)" title url))
                      (t url)))))
    (setq occhima/nyxt--insert-marker nil)
    (message "Inserted %s" title)))

(map! :leader
      :desc "Connect to Nyxt" "o n" #'occhima/nyxt-connect
      :desc "Insert Nyxt link" "i n" #'occhima/nyxt-insert-current-link)

(map! :after sly
      :map lisp-mode-map
      :localleader
      :desc "Connect to Nyxt" "n" #'occhima/nyxt-connect)

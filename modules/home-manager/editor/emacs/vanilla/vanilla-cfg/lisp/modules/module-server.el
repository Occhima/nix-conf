;;; module-server.el --- Emacs daemon and emacsclient frames -*- lexical-binding: t; -*-

(require 'core-evil)
(require 'core-ui)

(defconst occhima/client-frame-parameters
  '((width . 120)
    (height . 38)
    (internal-border-width . 10)
    (tool-bar-lines . 0)
    (menu-bar-lines . 0)
    (vertical-scroll-bars . nil))
  "Frame parameters applied to every graphical `emacsclient' frame.")

(defun occhima/server-setup-frame (&optional frame)
  "Apply the appearance a daemon FRAME cannot inherit from startup."
  (let ((frame (or frame (selected-frame))))
    (when (display-graphic-p frame)
      (occhima/apply-fonts frame)
      (dolist (parameter occhima/client-frame-parameters)
        (set-frame-parameter frame (car parameter) (cdr parameter)))
      (when (fboundp 'nerd-icons-set-font)
        (nerd-icons-set-font nil frame)))
    (with-selected-frame frame
      (when (fboundp 'doom-modeline-refresh-font-width-cache)
        (doom-modeline-refresh-font-width-cache)))))

(defun occhima/close-frame ()
  "Close the current frame or client without stopping the daemon."
  (interactive)
  (cond ((frame-parameter nil 'client)
         (server-save-buffers-kill-terminal nil))
        ((cdr (visible-frame-list))
         (delete-frame))
        ((daemonp)
         (message "Last frame belongs to the daemon; use `SPC q K' to stop it"))
        (t
         (save-buffers-kill-emacs))))

(defun occhima/kill-server ()
  "Save every buffer and stop the daemon."
  (interactive)
  (save-some-buffers nil t)
  (kill-emacs))

(defun occhima/restart-server ()
  "Restart the systemd user unit backing the daemon."
  (interactive)
  (when (yes-or-no-p "Restart the Emacs daemon? ")
    (save-some-buffers nil t)
    (call-process "systemctl" nil 0 nil "--user" "restart" "emacs")))

(use-package server
  :ensure nil
  :init
  (setq server-client-instructions nil)
  :config
  (unless (server-running-p)
    (server-start)))

(use-package with-editor
  :hook ((eshell-mode
          shell-mode
          vterm-mode
          eat-mode)
         . with-editor-export-editor))

(add-hook 'server-after-make-frame-hook #'occhima/server-setup-frame)
(add-hook 'after-make-frame-functions #'occhima/server-setup-frame)

(occhima/leader
  "q f" '(occhima/close-frame :wk "Close frame")
  "q q" '(occhima/close-frame :wk "Quit client")
  "q K" '(occhima/kill-server :wk "Kill daemon")
  "q R" '(occhima/restart-server :wk "Restart daemon"))

(provide 'module-server)
;;; module-server.el ends here

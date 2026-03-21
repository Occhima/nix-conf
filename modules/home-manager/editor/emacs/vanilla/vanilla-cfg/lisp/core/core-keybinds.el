;;; core-keybinds.el --- Centralized keymaps -*- lexical-binding: t; -*-

(require 'core-evil)

(defun occhima/delete-all-org-buffers ()
  "Close all open `org-mode' buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'org-mode)
        (kill-buffer buffer)))))

(defun occhima/open-agenda ()
  "Open the org agenda dashboard."
  (interactive)
  (org-agenda nil "o"))

(occhima/leadrr
  "f" '(:ignore t :which-key "files")
  "ff" #'find-file
  "fr" #'recentf-open-files
  "b" '(:ignore t :which-key "buffers")
  "bb" #'switch-to-buffer
  "bk" #'kill-current-buffer
  "d" '(:ignore t :which-key "dired")
  "dd" #'dired
  "dj" #'dired-jump
  "o" '(:ignore t :which-key "org")
  "oa" #'occhima/open-agenda
  "oc" #'org-capture
  "t" '(:ignore t :which-key "toggles")
  "tn" #'display-line-numbers-mode)

(occhima/local-leader
  :keymaps 'org-mode-map
  "o" #'occhima/open-agenda
  "d" #'occhima/delete-all-org-buffers)

(with-eval-after-load 'nix-mode
  (occhima/local-leader
    :keymaps 'nix-mode-map
    "f" #'nix-flake))

(provide 'core-keybinds)
;;; core-keybinds.el ends here

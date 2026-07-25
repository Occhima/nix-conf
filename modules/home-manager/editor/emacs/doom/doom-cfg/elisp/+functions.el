;;; +functions.el -*- lexical-binding: t; -*-

(defun occhima/delete-all-org-buffers ()
  "Kill every live Org buffer."
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and (buffer-live-p buffer)
               (with-current-buffer buffer
                 (derived-mode-p 'org-mode)))
      (kill-buffer buffer))))

(map! :leader
      :desc "Calendar" "o c" #'=calendar)

(map! :after org
      :map org-mode-map
      :localleader
      :desc "Kill all Org buffers" "d" #'occhima/delete-all-org-buffers)

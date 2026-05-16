;;;###autoload
(defun +just/run ()
  "Open justl in the current project root."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (justl)))

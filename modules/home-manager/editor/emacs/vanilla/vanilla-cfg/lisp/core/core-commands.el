;;; core-commands.el --- Commands behind Doom's default leader keys -*- lexical-binding: t; -*-

(require 'core-paths)

(defconst occhima/config-source-directory
  "~/.config/flake/modules/home-manager/editor/emacs/vanilla/vanilla-cfg/")

(defconst occhima/lookup-providers
  '(("DuckDuckGo" . "https://duckduckgo.com/?q=%s")
    ("Doom Emacs issues" . "https://github.com/doomemacs/doomemacs/issues?q=is%%3Aissue+%s")
    ("StackOverflow" . "https://stackoverflow.com/search?q=%s")
    ("GitHub" . "https://github.com/search?ref=simplesearch&q=%s")
    ("YouTube" . "https://youtube.com/results?aq=f&oq=&search_query=%s")
    ("MDN" . "https://developer.mozilla.org/en-US/search?q=%s")
    ("Arch Wiki" . "https://wiki.archlinux.org/index.php?search=%s&title=Special%3ASearch&wprov=acrw1")
    ("AUR" . "https://aur.archlinux.org/packages?O=0&K=%s"))
  "Online search engines for `occhima/lookup-online', ported from the Doom config.")

(defvar occhima/lookup-last-provider (caar occhima/lookup-providers))

(defconst occhima/desktop-directory
  (expand-file-name "desktop/" occhima/state-directory))

;;; Buffers

(defun occhima/new-empty-buffer ()
  "Create and switch to a new empty buffer."
  (interactive)
  (switch-to-buffer (generate-new-buffer "untitled")))

(defun occhima/switch-to-last-buffer ()
  "Switch to the most recently visited buffer."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) t)))

(defun occhima/open-scratch-buffer ()
  "Pop up the persistent scratch buffer."
  (interactive)
  (pop-to-buffer (get-scratch-buffer-create)))

(defun occhima/switch-to-scratch-buffer ()
  "Switch to the persistent scratch buffer in the current window."
  (interactive)
  (switch-to-buffer (get-scratch-buffer-create)))

(defun occhima/workspace-buffer ()
  "Switch among the current project's buffers, or all buffers outside one."
  (interactive)
  (if (project-current)
      (consult-project-buffer)
    (consult-buffer)))

(defun occhima/real-buffer-p (buffer)
  "Return non-nil when BUFFER visits a file or a directory."
  (or (buffer-file-name buffer)
      (with-current-buffer buffer (derived-mode-p 'dired-mode))))

(defun occhima/kill-other-buffers ()
  "Kill file and Dired buffers other than the current one."
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and (not (eq buffer (current-buffer)))
               (occhima/real-buffer-p buffer))
      (kill-buffer buffer))))

(defun occhima/kill-all-buffers ()
  "Kill every file and Dired buffer, then show the dashboard."
  (interactive)
  (dolist (buffer (buffer-list))
    (when (occhima/real-buffer-p buffer)
      (kill-buffer buffer)))
  (delete-other-windows)
  (if (fboundp 'dashboard-open)
      (dashboard-open)
    (switch-to-buffer (get-scratch-buffer-create))))

(defun occhima/kill-buried-buffers ()
  "Kill file and Dired buffers not shown in any window."
  (interactive)
  (let ((count 0))
    (dolist (buffer (buffer-list))
      (when (and (occhima/real-buffer-p buffer)
                 (not (get-buffer-window buffer t)))
        (kill-buffer buffer)
        (setq count (1+ count))))
    (message "Killed %d buried buffers" count)))

(defun occhima/toggle-narrow-buffer (begin end)
  "Narrow to the region between BEGIN and END or the defun; widen if narrowed."
  (interactive (if (use-region-p) (list (region-beginning) (region-end)) (list nil nil)))
  (cond ((buffer-narrowed-p) (widen))
        (begin (narrow-to-region begin end) (deactivate-mark))
        (t (narrow-to-defun))))

(defun occhima/copy-buffer-contents ()
  "Copy the entire current buffer without moving point."
  (interactive)
  (kill-new (buffer-substring-no-properties (point-min) (point-max)))
  (message "Copied buffer contents"))

;;; Files

(defun occhima/buffer-path ()
  "Return the path represented by the current buffer."
  (or buffer-file-name
      (and (derived-mode-p 'dired-mode) default-directory)
      (user-error "The current buffer does not represent a file")))

(defun occhima/copy-buffer-path ()
  "Copy the current buffer's absolute path."
  (interactive)
  (let ((path (expand-file-name (occhima/buffer-path))))
    (kill-new path)
    (message "Copied %s" path)))

(defun occhima/copy-buffer-path-relative-to-project ()
  "Copy the current buffer's path relative to its project."
  (interactive)
  (let* ((path (expand-file-name (occhima/buffer-path)))
         (project (or (project-current nil (file-name-directory path))
                      (user-error "The current buffer is not in a project")))
         (relative-path (file-relative-name path (project-root project))))
    (kill-new relative-path)
    (message "Copied %s" relative-path)))

(defun occhima/find-file-in-config ()
  "Find a file in the editable flake source of this configuration."
  (interactive)
  (let ((default-directory occhima/config-source-directory))
    (call-interactively #'find-file)))

(defun occhima/browse-config ()
  "Browse the editable flake source of this configuration."
  (interactive)
  (dired occhima/config-source-directory))

(defun occhima/browse-emacs-directory ()
  "Browse `user-emacs-directory'."
  (interactive)
  (dired user-emacs-directory))

(defun occhima/find-file-under-here ()
  "Find a file recursively below `default-directory'."
  (interactive)
  (consult-fd default-directory))

(defun occhima/delete-this-file ()
  "Delete the current file, after confirmation, and kill its buffer."
  (interactive)
  (let ((file (or buffer-file-name (user-error "Buffer is not visiting a file"))))
    (when (yes-or-no-p (format "Really delete %s? " (abbreviate-file-name file)))
      (delete-file file delete-by-moving-to-trash)
      (kill-buffer)
      (message "Deleted %s" (abbreviate-file-name file)))))

(defun occhima/copy-this-file (new-path)
  "Copy the current file to NEW-PATH and visit the copy."
  (interactive
   (list (read-file-name "Copy file to: " nil nil nil
                         (and buffer-file-name (file-name-nondirectory buffer-file-name)))))
  (copy-file (or buffer-file-name (user-error "Buffer is not visiting a file"))
             new-path 1)
  (find-file new-path))

(defun occhima/sudo-file-path (file)
  "Return a TRAMP path that opens local FILE as root."
  (concat "/sudo::" file))

(defun occhima/sudo-find-file (file)
  "Open FILE as root."
  (interactive "FOpen file as root: ")
  (find-file (occhima/sudo-file-path (expand-file-name file))))

(defun occhima/sudo-this-file ()
  "Reopen the current file as root."
  (interactive)
  (occhima/sudo-find-file (occhima/buffer-path)))

(defun occhima/sudo-save-buffer ()
  "Save the current buffer to its file as root."
  (interactive)
  (let ((file (occhima/sudo-file-path
               (or buffer-file-name (user-error "Buffer is not visiting a file")))))
    (write-region nil nil file)
    (set-buffer-modified-p nil)
    (message "Saved %s as root" (abbreviate-file-name buffer-file-name))))

;;; Insert

(defun occhima/insert-file-path (&optional full)
  "Insert the current file name, or the full path with prefix argument FULL."
  (interactive "P")
  (let ((path (occhima/buffer-path)))
    (insert (if full (abbreviate-file-name path) (file-name-nondirectory path)))))

(defun occhima/insert-file-full-path ()
  "Insert the current file's full path."
  (interactive)
  (occhima/insert-file-path t))

(defun occhima/insert-shell-output ()
  "Insert a shell command's output through evil's :r!."
  (interactive)
  (evil-ex "r!echo "))

;;; Search

(defun occhima/symbol-at-point ()
  "Return the symbol at point or the active region as a string."
  (if (use-region-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (thing-at-point 'symbol t)))

(defun occhima/search-project-for-symbol-at-point ()
  "Search the project for the symbol at point."
  (interactive)
  (consult-ripgrep nil (occhima/symbol-at-point)))

(defun occhima/search-buffer-for-symbol-at-point ()
  "Search the buffer for the symbol at point."
  (interactive)
  (consult-line (occhima/symbol-at-point)))

(defun occhima/search-cwd ()
  "Search the current directory."
  (interactive)
  (consult-ripgrep default-directory))

(defun occhima/search-other-cwd (directory)
  "Search DIRECTORY."
  (interactive "DSearch directory: ")
  (consult-ripgrep directory))

(defun occhima/search-other-project ()
  "Search another known project."
  (interactive)
  (consult-ripgrep (project-prompt-project-dir)))

(defun occhima/search-config ()
  "Search this configuration's flake source."
  (interactive)
  (consult-ripgrep occhima/config-source-directory))

(defun occhima/search-notes ()
  "Search `org-directory'."
  (interactive)
  (consult-ripgrep org-directory))

(defun occhima/search-notes-for-symbol-at-point ()
  "Search `org-directory' for the symbol at point."
  (interactive)
  (consult-ripgrep org-directory (occhima/symbol-at-point)))

(defun occhima/find-in-notes ()
  "Find a file below `org-directory'."
  (interactive)
  (consult-fd org-directory))

(defun occhima/browse-notes ()
  "Browse `org-directory'."
  (interactive)
  (dired org-directory))

(defun occhima/lookup-online (query &optional provider)
  "Search QUERY with PROVIDER from `occhima/lookup-providers'."
  (interactive
   (let ((provider (if current-prefix-arg
                       (completing-read "Search on: " occhima/lookup-providers nil t)
                     occhima/lookup-last-provider)))
     (list (read-string (format "Search %s: " provider) (occhima/symbol-at-point))
           provider)))
  (let ((provider (or provider occhima/lookup-last-provider)))
    (setq occhima/lookup-last-provider provider)
    (browse-url (format (alist-get provider occhima/lookup-providers nil nil #'equal)
                        (url-hexify-string query)))))

(defun occhima/lookup-online-select ()
  "Search online after choosing the search engine."
  (interactive)
  (let ((current-prefix-arg t))
    (call-interactively #'occhima/lookup-online)))

;;; Code

(defun occhima/eval-dwim (begin end)
  "Evaluate the region between BEGIN and END, or the buffer, in its language."
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-max))))
  (cond ((derived-mode-p 'python-base-mode) (python-shell-send-region begin end))
        ((derived-mode-p 'ess-mode) (ess-eval-region begin end nil))
        ((derived-mode-p 'lisp-mode) (sly-eval-region begin end))
        (t (eval-region begin end t))))

(defun occhima/eval-and-replace (begin end)
  "Replace the Emacs Lisp between BEGIN and END with its value."
  (interactive "r")
  (let ((value (eval (read (buffer-substring-no-properties begin end)) t)))
    (delete-region begin end)
    (goto-char begin)
    (insert (prin1-to-string value))))

(defun occhima/open-repl (&optional same-window)
  "Open the REPL for the current major mode, in another window unless SAME-WINDOW."
  (interactive)
  (let ((display-buffer-overriding-action
         (if same-window '(display-buffer-same-window) display-buffer-overriding-action)))
    (call-interactively
     (cond ((derived-mode-p 'python-base-mode) #'run-python)
           ((derived-mode-p 'ess-mode) #'R)
           ((derived-mode-p 'julia-mode) #'julia-repl)
           ((derived-mode-p 'lisp-mode) #'sly)
           ((derived-mode-p 'nix-mode 'nix-ts-mode) #'nix-repl)
           ((derived-mode-p 'haskell-mode) #'haskell-interactive-bring)
           ((derived-mode-p 'sh-mode 'bash-ts-mode) #'shell)
           (t #'ielm)))))

(defun occhima/open-repl-same-window ()
  "Open the current major mode's REPL in the current window."
  (interactive)
  (occhima/open-repl t))

(defun occhima/delete-trailing-newlines ()
  "Delete blank lines at the end of the buffer."
  (interactive)
  (save-excursion
    (goto-char (point-max))
    (delete-blank-lines)))

;;; Project

(defun occhima/project-scratch-buffer ()
  "Return the scratch buffer of the current project."
  (let* ((root (project-root (project-current t)))
         (buffer (get-buffer-create
                  (format "*scratch:%s*" (file-name-nondirectory (directory-file-name root))))))
    (with-current-buffer buffer
      (unless (derived-mode-p 'lisp-interaction-mode)
        (setq default-directory root)
        (lisp-interaction-mode)))
    buffer))

(defun occhima/pop-project-scratch-buffer ()
  "Pop up the current project's scratch buffer."
  (interactive)
  (pop-to-buffer (occhima/project-scratch-buffer)))

(defun occhima/switch-to-project-scratch-buffer ()
  "Switch to the current project's scratch buffer."
  (interactive)
  (switch-to-buffer (occhima/project-scratch-buffer)))

(defun occhima/browse-other-project ()
  "Browse the root of another known project."
  (interactive)
  (dired (project-prompt-project-dir)))

(defun occhima/save-project-buffers ()
  "Save every modified file buffer in the current project."
  (interactive)
  (let ((buffers (project-buffers (project-current t))))
    (save-some-buffers t (lambda () (memq (current-buffer) buffers)))))

;;; Workspaces

(defun occhima/workspace-new-named (name)
  "Create a workspace tab called NAME."
  (interactive "sWorkspace name: ")
  (tab-new)
  (tab-rename name))

(defun occhima/workspace-kill-session ()
  "Close every workspace tab but the current one."
  (interactive)
  (tab-close-other))

;;; Sessions

(defun occhima/session-save (&optional directory)
  "Save the session to DIRECTORY, or the default desktop directory."
  (interactive)
  (require 'desktop)
  (let ((directory (or directory occhima/desktop-directory)))
    (make-directory directory t)
    (desktop-save directory t)
    (message "Saved session to %s" (abbreviate-file-name directory))))

(defun occhima/session-load (&optional directory)
  "Load the session saved in DIRECTORY, or the default desktop directory."
  (interactive)
  (require 'desktop)
  (desktop-read (or directory occhima/desktop-directory)))

(defun occhima/session-save-to (directory)
  "Save the session to DIRECTORY."
  (interactive "DSave session to: ")
  (occhima/session-save directory))

(defun occhima/session-load-from (directory)
  "Load the session saved in DIRECTORY."
  (interactive "DLoad session from: ")
  (occhima/session-load directory))

;;; Windows

(defun occhima/window-split-and-follow ()
  "Split the window below and select the new window."
  (interactive)
  (select-window (split-window-below)))

(defun occhima/window-vsplit-and-follow ()
  "Split the window right and select the new window."
  (interactive)
  (select-window (split-window-right)))

(defun occhima/window-maximize-buffer ()
  "Show only the current window; call again to restore the layout."
  (interactive)
  (if (and (one-window-p) (bound-and-true-p winner-mode))
      (winner-undo)
    (delete-other-windows)))

;;; Toggles

(define-minor-mode occhima/big-font-mode
  "Show every frame in a larger font, for presentations."
  :global t
  (set-face-attribute 'default nil
                      :height (if occhima/big-font-mode
                                  (round (* 1.5 occhima/font-height))
                                occhima/font-height)))

(defun occhima/toggle-indent-style ()
  "Switch the current buffer between tabs and spaces for indentation."
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode))
  (message "Indent style: %s" (if indent-tabs-mode "tabs" "spaces")))

;;; Org

(defun occhima/delete-all-org-buffers ()
  "Close all `org-mode' buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'org-mode)
        (kill-buffer buffer)))))

(defun occhima/open-agenda ()
  "Open the personal org agenda."
  (interactive)
  (org-agenda nil "o"))

(provide 'core-commands)
;;; core-commands.el ends here

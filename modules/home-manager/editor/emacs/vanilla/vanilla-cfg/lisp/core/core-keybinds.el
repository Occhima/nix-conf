;;; core-keybinds.el --- Centralized keymaps -*- lexical-binding: t; -*-

(require 'core-evil)

(defun occhima/new-empty-buffer ()
  "Create and switch to a new empty buffer."
  (interactive)
  (switch-to-buffer (generate-new-buffer "untitled")))

(defun occhima/switch-to-last-buffer ()
  "Switch to the most recently visited buffer."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) t)))

(defun occhima/open-scratch-buffer ()
  "Switch to the persistent scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*")))

(defun occhima/find-file-in-config ()
  "Find a file below `user-emacs-directory'."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (call-interactively #'find-file)))

(defun occhima/kill-other-buffers ()
  "Kill user buffers other than the current one."
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and (not (eq buffer (current-buffer)))
               (not (string-prefix-p " " (buffer-name buffer))))
      (kill-buffer buffer))))

(defun occhima/copy-buffer-contents ()
  "Copy the entire current buffer without moving point."
  (interactive)
  (kill-new (buffer-substring-no-properties (point-min) (point-max)))
  (message "Copied buffer contents"))

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
         (project (project-current nil (file-name-directory path))))
    (unless project
      (user-error "The current buffer is not in a project"))
    (let ((relative-path (file-relative-name path (project-root project))))
      (kill-new relative-path)
      (message "Copied %s" relative-path))))

(defun occhima/save-project-buffers ()
  "Save every modified file buffer in the current project."
  (interactive)
  (let ((buffers (project-buffers (project-current t))))
    (save-some-buffers
     t
     (lambda ()
       (memq (current-buffer) buffers)))))

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

(occhima/leader
  "TAB" '(:prefix-command occhima/workspace-map :wk "workspace")
  "b" '(:prefix-command occhima/buffer-map :wk "buffer")
  "c" '(:prefix-command occhima/code-map :wk "code")
  "f" '(:prefix-command occhima/file-map :wk "file")
  "g" '(:prefix-command occhima/git-map :wk "git")
  "i" '(:prefix-command occhima/insert-map :wk "insert")
  "j" '(:prefix-command occhima/just-map :wk "just")
  "m" '(:prefix-command occhima/local-leader-map :wk "localleader")
  "n" '(:prefix-command occhima/notes-map :wk "notes")
  "nr" '(:prefix-command occhima/roam-map :wk "roam")
  "O" '(:prefix-command occhima/agent-map :wk "opencode")
  "o" '(:prefix-command occhima/open-map :wk "open")
  "oa" '(:prefix-command occhima/agenda-map :wk "org agenda")
  "p" '(:prefix-command occhima/project-map :wk "project")
  "q" '(:prefix-command occhima/quit-map :wk "quit/session")
  "s" '(:prefix-command occhima/search-map :wk "search")
  "t" '(:prefix-command occhima/toggle-map :wk "toggle")

  ";" '(pp-eval-expression :wk "Eval expression")
  ":" '(execute-extended-command :wk "M-x")
  "x" '(occhima/open-scratch-buffer :wk "Scratch buffer")
  "X" '(org-capture :wk "Org capture")
  "u" '(universal-argument :wk "Universal argument")
  "w" '(:keymap evil-window-map :wk "window")
  "h" '(:keymap help-map :wk "help")
  "." '(find-file :wk "Find file")
  "," '(switch-to-buffer :wk "Switch buffer")
  "`" '(occhima/switch-to-last-buffer :wk "Last buffer")
  "'" '(vertico-repeat :wk "Resume search")
  "/" '(consult-ripgrep :wk "Search project")
  "SPC" '(project-find-file :wk "Find project file")
  "RET" '(bookmark-jump :wk "Jump to bookmark")

  "TAB TAB" '(tab-bar-switch-to-tab :wk "Switch workspace")
  "TAB `" '(tab-recent :wk "Last workspace")
  "TAB [" '(tab-previous :wk "Previous workspace")
  "TAB ]" '(tab-next :wk "Next workspace")
  "TAB d" '(tab-close :wk "Delete workspace")
  "TAB n" '(tab-new :wk "New workspace")
  "TAB r" '(tab-rename :wk "Rename workspace")

  "b [" '(previous-buffer :wk "Previous buffer")
  "b ]" '(next-buffer :wk "Next buffer")
  "b b" '(switch-to-buffer :wk "Switch buffer")
  "b c" '(clone-indirect-buffer :wk "Clone buffer")
  "b C" '(clone-indirect-buffer-other-window :wk "Clone in other window")
  "b d" '(kill-current-buffer :wk "Kill buffer")
  "b i" '(ibuffer :wk "Ibuffer")
  "b k" '(kill-current-buffer :wk "Kill buffer")
  "b l" '(occhima/switch-to-last-buffer :wk "Last buffer")
  "b m" '(bookmark-set :wk "Set bookmark")
  "b M" '(bookmark-delete :wk "Delete bookmark")
  "b n" '(next-buffer :wk "Next buffer")
  "b N" '(occhima/new-empty-buffer :wk "New buffer")
  "b O" '(occhima/kill-other-buffers :wk "Kill other buffers")
  "b p" '(previous-buffer :wk "Previous buffer")
  "b r" '(revert-buffer :wk "Revert buffer")
  "b R" '(rename-buffer :wk "Rename buffer")
  "b s" '(basic-save-buffer :wk "Save buffer")
  "b S" '(save-some-buffers :wk "Save all buffers")
  "b x" '(occhima/open-scratch-buffer :wk "Scratch buffer")
  "b y" '(occhima/copy-buffer-contents :wk "Yank buffer")
  "b z" '(bury-buffer :wk "Bury buffer")

  "c a" '(eglot-code-actions :wk "Code action")
  "c c" '(compile :wk "Compile")
  "c C" '(recompile :wk "Recompile")
  "c d" '(xref-find-definitions :wk "Definition")
  "c D" '(xref-find-references :wk "References")
  "c i" '(eglot-find-implementation :wk "Implementations")
  "c k" '(eldoc-doc-buffer :wk "Documentation")
  "c r" '(eglot-rename :wk "Rename symbol")
  "c w" '(delete-trailing-whitespace :wk "Delete trailing whitespace")
  "c x" '(consult-flymake :wk "Diagnostics")

  "f d" '(dired :wk "Find directory")
  "f e" '(occhima/find-file-in-config :wk "Find in config")
  "f f" '(find-file :wk "Find file")
  "f l" '(locate :wk "Locate file")
  "f r" '(recentf-open-files :wk "Recent files")
  "f s" '(basic-save-buffer :wk "Save file")
  "f S" '(write-file :wk "Save file as")
  "f y" '(occhima/copy-buffer-path :wk "Yank file path")
  "f Y" '(occhima/copy-buffer-path-relative-to-project
          :wk "Yank project-relative path")

  "i e" '(emoji-search :wk "Emoji")
  "i r" '(evil-show-registers :wk "Register")
  "i u" '(insert-char :wk "Unicode")

  "n a" '(org-agenda :wk "Org agenda")
  "n b" '(citar-open-notes :wk "Bibliographic notes")
  "n l" '(org-store-link :wk "Store link")
  "n m" '(org-tags-view :wk "Tags search")
  "n n" '(org-capture :wk "Org capture")
  "n N" '(org-capture-goto-target :wk "Goto capture")
  "n s" '(org-search-view :wk "Search notes")
  "n t" '(org-todo-list :wk "Todo list")
  "n v" '(org-search-view :wk "View search")
  "nr a" '(org-roam-node-random :wk "Random node")
  "nr f" '(org-roam-node-find :wk "Find node")
  "nr F" '(org-roam-ref-find :wk "Find reference")
  "nr g" '(org-roam-graph :wk "Show graph")
  "nr i" '(org-roam-node-insert :wk "Insert node")
  "nr n" '(org-roam-capture :wk "Capture node")
  "nr r" '(org-roam-buffer-toggle :wk "Toggle roam buffer")
  "nr s" '(org-roam-db-sync :wk "Sync database")

  "o A" '(org-agenda :wk "Org agenda")
  "o a a" '(org-agenda :wk "Agenda")
  "o a m" '(org-tags-view :wk "Tags search")
  "o a t" '(org-todo-list :wk "Todo list")
  "o a v" '(org-search-view :wk "View search")
  "o b" '(browse-url-of-file :wk "Default browser")
  "o c" '(calendar :wk "Calendar")
  "o f" '(make-frame :wk "New frame")
  "o F" '(select-frame-by-name :wk "Select frame")
  "o -" '(dired-jump :wk "Dired")
  "o /" '(dirvish :wk "Dirvish")
  "o p" '(dirvish-side :wk "Project sidebar")

  "p ." '(project-dired :wk "Browse project")
  "p b" '(consult-project-buffer :wk "Project buffer")
  "p c" '(project-compile :wk "Compile project")
  "p d" '(project-forget-project :wk "Forget project")
  "p f" '(project-find-file :wk "Find project file")
  "p k" '(project-kill-buffers :wk "Kill project buffers")
  "p p" '(project-switch-project :wk "Switch project")
  "p s" '(occhima/save-project-buffers :wk "Save project buffers")

  "s b" '(consult-line :wk "Search buffer")
  "s B" '(consult-line-multi :wk "Search open buffers")
  "s d" '(consult-ripgrep :wk "Search directory")
  "s f" '(locate :wk "Locate file")
  "s g" '(consult-gh-search-repos :wk "Search GitHub repos")
  "s i" '(consult-imenu :wk "Jump to symbol")
  "s I" '(consult-imenu-multi :wk "Symbols in open buffers")
  "s j" '(evil-show-jumps :wk "Jump list")
  "s m" '(bookmark-jump :wk "Bookmark")
  "s o" '(consult-omni-multi :wk "Omni search")
  "s p" '(consult-ripgrep :wk "Search project")
  "s r" '(evil-show-marks :wk "Jump to mark")
  "s s" '(consult-line :wk "Search buffer")

  "t c" '(global-display-fill-column-indicator-mode :wk "Fill column")
  "t f" '(flymake-mode :wk "Flymake")
  "t F" '(toggle-frame-fullscreen :wk "Fullscreen")
  "t l" '(display-line-numbers-mode :wk "Line numbers")
  "t r" '(read-only-mode :wk "Read-only")
  "t s" '(jinx-mode :wk "Spell checker")
  "t v" '(visible-mode :wk "Visible mode")
  "t w" '(visual-line-mode :wk "Soft wrapping"))

(occhima/local-leader
  "d" '(occhima/delete-all-org-buffers :wk "Kill Org buffers")
  "f" '(nix-flake :wk "Nix flake")
  "o" '(occhima/open-agenda :wk "Org agenda"))

(provide 'core-keybinds)
;;; core-keybinds.el ends here

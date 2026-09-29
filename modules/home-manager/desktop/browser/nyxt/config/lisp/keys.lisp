(in-package #:nyxt-user)

(defvar *leader* "C-M-o"
  "Prefix every binding of this configuration hangs off; change it here only.")

(defun leader (&rest keys-and-commands)
  "KEYS-AND-COMMANDS, alternating keyspec and command, with `*leader*' prepended
to every keyspec, ready for `keymaps:define-keyscheme-map'."
  (loop for (keys command) on keys-and-commands by #'cddr
        append (list (str:concat *leader* " " keys) command)))

(defun define-leader-group (keys name)
  "Name the prefix `*leader*' KEYS as NAME in which-key, or the leader itself
when KEYS is empty."
  (setf (gethash (if (str:emptyp keys) *leader* (str:concat *leader* " " keys))
                 *which-key-labels*)
        name))

(define-leader-group "h" "+hint")

(define-configuration base-mode
  ((keyscheme-map
    ;; notinline turns off the function's compiler macro, which type-checks
    ;; literal binding lists and signals on the computed one `leader' builds.
    (locally (declare (notinline keymaps:define-keyscheme-map))
     (keymaps:define-keyscheme-map
      "research" (list :import %slot-value%)
      nyxt/keyscheme:default
      (list* "C-'" 'edit-with-external-editor
             (leader
              ;; Emacs and research
              "r" 'capture-in-org-roam
              "l" 'read-later
              "p" 'add-paper
              "e" 'open-in-emacs
              "s" 'save-article-to-roam
              "d" 'open-pdf-in-emacs-current
              ;; Reading and annotating
              "m" 'reader-mode
              "a" 'nyxt/mode/annotate:annotate-highlighted-text
              "A" 'nyxt/mode/annotate:annotate-current-url
              "v" 'nyxt/mode/annotate:show-annotations-for-current-url
              "V" 'nyxt/mode/annotate:show-annotations
              "f" 'nyxt/mode/search-buffer:search-buffers
              ;; Copying
              "y" 'copy-org-link
              "Y" 'copy-markdown-link
              "c" 'copy-clean-url
              ;; Navigation
              "u" 'go-up
              "U" 'go-root
              "+" 'increment-url
              "hyphen" 'decrement-url
              ;; Site state and session
              "t" 'remember-site-modes
              "T" 'forget-site-modes
              "q" 'toggle-mute
              "R" 'restore-session
              "i" 'fill-login
              "k" 'nyxt/mode/macro-edit:edit-macro
              "w" 'play-in-mpv-current
              ;; Hints
              "h w" 'hint-play-in-mpv
              "h e" 'hint-open-in-emacs
              "h r" 'hint-capture-in-org-roam
              "h p" 'hint-add-paper
              "h y" 'hint-copy-org-link
              "h c" 'hint-copy-clean-url
              "h d" 'hint-open-pdf-in-emacs)))))))

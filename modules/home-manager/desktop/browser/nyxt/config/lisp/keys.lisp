(in-package #:nyxt-user)

(define-configuration base-mode
  ((keyscheme-map
    (keymaps:define-keyscheme-map
      "research" (list :import %slot-value%)
      nyxt/keyscheme:default
      (list "C-'" 'edit-with-external-editor
            "C-M-o r" 'capture-in-org-roam
            "C-M-o l" 'read-later
            "C-M-o p" 'add-paper
            "C-M-o e" 'open-in-emacs
            "C-M-o m" 'reader-mode
            "C-M-o s" 'save-article-to-roam
            "C-M-o a" 'nyxt/mode/annotate:annotate-highlighted-text
            "C-M-o A" 'nyxt/mode/annotate:annotate-current-url
            "C-M-o v" 'nyxt/mode/annotate:show-annotations-for-current-url
            "C-M-o V" 'nyxt/mode/annotate:show-annotations
            "C-M-o k" 'nyxt/mode/macro-edit:edit-macro
            "C-M-o f" 'nyxt/mode/search-buffer:search-buffers
            "C-M-o t" 'remember-site-modes
            "C-M-o T" 'forget-site-modes)))))

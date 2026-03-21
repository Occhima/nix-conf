
(use-package! consult-gh
  ;; :after consult
  :custom
  (consult-gh-show-preview t)
  (consult-gh-preview-key "M-o")
  (consult-gh-repo-action #'consult-gh--repo-browse-files-action)
  (consult-gh-issue-action #'consult-gh--issue-view-action)
  (consult-gh-pr-action #'consult-gh--pr-view-action)
  (consult-gh-code-action #'consult-gh--code-view-action)
  (consult-gh-file-action #'consult-gh--files-view-action)
  (consult-gh-large-file-warning-threshold 2500000)
  (consult-gh-prioritize-local-folder 'suggest)
  :config

  ;;(after! (forge transient)
   ;; (require 'consult-gh-embark)
   ;; (require 'consult-gh-transient)
   ;; )

  )


(use-package! blamer
  :config
  (global-blamer-mode)
  )

(use-package! devdocs
  )

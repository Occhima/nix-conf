(use-package! just-mode
  :mode ("\\(J\\|j\\)ustfile\\'" "\\.just\\'")
  :config
  (map! :map just-mode-map
        :localleader
        "r" #'justl-exec-recipe
        "R" #'justl-exec-default-recipe
        "j" #'justl
        "=" #'just-format-buffer))

(use-package! just-ts-mode
  :defer t)

(use-package! justl
  :commands (justl justl-exec-recipe justl-exec-default-recipe)
  :config
  (map! :map justl-compile-mode-map
        :localleader "j" #'justl)
  (map! :leader
        (:prefix ("j" . "just")
         :desc "Open justl"     "j" #'justl
         :desc "Run recipe"     "r" #'justl-exec-recipe)))

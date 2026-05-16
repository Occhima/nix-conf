(use-package! justl
  :commands (justl justl-exec-recipe)
  :config
  (map! :leader
        (:prefix ("j" . "just")
         :desc "Open justl"       "j" #'justl
         :desc "Execute recipe"   "e" #'justl-exec-recipe)))

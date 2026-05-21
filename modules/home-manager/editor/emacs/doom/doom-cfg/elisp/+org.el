(after! org
  (require 'corg)
  (add-hook 'org-mode-hook #'corg-setup)
  ;; (advice-remove 'org-babel-do-load-languages #'ignore)
  (remove-hook 'org-mode-hook #'+org-make-last-point-visible-h)
  (add-to-list 'org-modules 'org-habit)
  ;; (add-to-list '+org-babel-mode-alist
  ;;              ;; '(julia . julia-snail)
  ;;              )
  (defalias '+org--restart-mode-h #'ignore)
  (setq org-tags-column -80
        org-hugo-base-dir "~/Dropbox/projects/org/hugo"
        org-latex-src-block-backend  'minted

        org-latex-packages-alist '(
                                   ("" "minted")
                                   ("" "mdframed")
                                   )
        org-latex-compiler "xelatex"
        org-latex-minted-options
        '(
          ("frame" . "lines")
          ("breaklines" . "true")
          ("fontsize" . "\\scriptsize")
          ("linenos" . "true")
          ("numbersep" . "5pt")
          ("tabsize" . "4")
          ("mathescape" . "true")
          ("showspaces" . "false")
          )
        org-latex-pdf-process
        '(
          "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f")

        org-todo-keywords
        '((sequence
           "TODO(t)"
           "PROJ(p)"
           "TO-READ(r)"
           "STRT(s)"
           "WAIT(w)"
           "HOLD(h)"
           "NEXT(n)"
           "IDEA(i)"
           "|"
           "DONE(d!)"
           "KILL(k@!)"))
        org-agenda-sticky nil
        org-use-property-inheritance t
        org-directory "~/Dropbox/projects/org"
        org-log-done 'time
        org-hide-emphasis-markers t
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t
        org-log-into-drawer t
        org-log-state-notes-into-drawer t
        org-log-repeat 'time
        org-todo-repeat-to-state "TODO"
        org-capture-templates
        '(
          ("f" "Finance")
          ("fc" "Credit Card" entry
           (file+headline "~/Dropbox/projects/finance/finance-2023.beancount" "Credit-Cards")
           "** IDEA %i%?"
           :prepend t
           :kill-buffer t)

          ("i" "IDEA")
          ("ia" "Academic" entry
           (file+headline "~/Dropbox/DropsyncFiles/ideas.org" "Academic")
           "** IDEA %i%?"
           :prepend t
           :kill-buffer t)
          ("t" "TODO")
          ("tp" "Personal" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Personal")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          ("ts" "Study" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Study")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          ("tb" "Bugs" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Bugs")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          ("to" "Shopping" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Shopping")
           "** TODO %i%? "
           :prepend t
           :kill-buffer t)
          ("te" "Emacs" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Emacs")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          ("th" "Health" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Health")
           "** TODO %i%? "
           :prepend t
           :kill-buffer t)
          ("tl" "Hacking" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Hacking")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          ("tw" "Work" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Work")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          ("tn" "Nyxt" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Nyxt")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)

          ("tN" "Numerai" entry
           (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Numerai")
           "** TODO %i%?"
           :prepend t
           :kill-buffer t)
          )
        +org-capture-notes-file "inbox.org"
        ))

;; Org modern
(global-org-modern-mode)

(after! org-agenda
  (require 'org-super-agenda)
  (org-super-agenda-mode)
  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 1
        org-agenda-files '("~/Dropbox/DropsyncFiles/todo.org"
                           "~/Dropbox/projects/org/gcal/personal.org"
                           "~/Dropbox/DropsyncFiles/habits.org"
                           "~/Dropbox/DropsyncFiles/ideas.org"
                           )
        org-agenda-start-on-weekday nil
        org-habit-show-all-today t
        org-habit-today-glyph ?⚡
        org-habit-completed-glyph ?+
        org-super-agenda-unmatched-name "⚡ Backlog"
        org-super-agenda-unmatched-order 50
        org-agenda-custom-commands
        '(

          ("n" "Next"
           (
            (alltodo "To-Do" ((org-agenda-overriding-header "")

                              (org-agenda-remove-tags t)
                              (org-super-agenda-groups
                               '(;; Each group has an implicit boolean OR operator between its selectors.
                                 (:name " ⚡ Next "
                                  :todo "NEXT"
                                  :discard (:anything t)
                                  )
                                 ))))))



          ("c" "Todos"
           (
            (alltodo "To-Do" ((org-agenda-overriding-header "")

                              (org-agenda-remove-tags t)
                              (org-super-agenda-groups
                               '(;; Each group has an implicit boolean OR operator between its selectors.
                                 (:name " :exclamation: Important"
                                  :priority "A")
                                 (:name "🌐 Nyxt"
                                  :tag "nyxt"
                                  )
                                 (:name "🎯 Goals"
                                  :tag "goals"
                                  )
                                 (:name " :construction_worker: Personal"
                                  :and (:tag ("personal") :todo "TODO"))
                                 (:name "💰 Numerai"
                                  :and (:tag ("numerai") :todo "TODO"))
                                 (:name ":book: Study"
                                  :and (:tag ("study") :todo "TODO"))
                                 (:name ":bug: Bugs"
                                  :and (:tag ("bugs") :todo "TODO"))
                                 (:name ":office: Work"
                                  :and (:tag ("work") :todo "TODO"))
                                 (:name ":floppy_disk: Emacs"
                                  :and (:tag ("emacs") :todo "TODO"))
                                 (:name ":syringe: Health"
                                  :and (:tag ("health") :todo "TODO"))
                                 (:name ":computer: Hacking"
                                  :and (:tag ("hacking") :todo "TODO"))
                                 (:name " :books: Books"
                                  :and (:tag ("books") :todo ("TO-READ"))
                                  :order 1)
                                 (:name ":moneybag: Shopping"
                                  :and (:tag ("shopping") :todo "TODO")
                                  :order 1)
                                 (:name " ⛔ On hold"
                                  :todo "HOLD"
                                  :discard (:anything t)
                                  :order 10)))))))

          ("o" "Personal Agenda"
           (
            (agenda "Agenda"
                    (
                     (org-agenda-span 5)
                     (org-agenda-skip-scheduled-if-done t)
                     (org-agenda-skip-timestamp-if-done t)
                     (org-habit-show-all-today t)
                     (org-agenda-skip-deadline-if-done t)
                     (org-agenda-overriding-header "\n ⚡ Agenda")
                     (org-agenda-remove-tags t)
                     (org-super-agenda-groups
                      '((:name "Today"
                         :time-grid t
                         :habit t
                         :date today
                         :category "personal"
                         :discard (:anything t)
                         :order 5))
                      )
                     )
                    )
            )
           )
          )
        )
  )

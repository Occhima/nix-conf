;;; module-org.el --- Org workflow -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :hook (org-mode . visual-line-mode)
  :custom
  (org-tags-column -80)
  (org-directory "~/Dropbox/projects/org")
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-log-state-notes-into-drawer t)
  (org-use-property-inheritance t)
  (org-hide-emphasis-markers t)
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  (org-todo-repeat-to-state "TODO")
  (org-todo-keywords
   '((sequence "TODO(t)" "PROJ(p)" "TO-READ(r)" "STRT(s)" "WAIT(w)" "HOLD(h)" "NEXT(n)" "IDEA(i)"
               "|" "DONE(d!)" "KILL(k@!)")))
  (org-capture-templates
   '(("f" "Finance")
     ("fc" "Credit Card" entry
      (file+headline "~/Dropbox/projects/finance/finance-2023.beancount" "Credit-Cards")
      "** IDEA %i%?" :prepend t :kill-buffer t)
     ("i" "IDEA")
     ("ia" "Academic" entry
      (file+headline "~/Dropbox/DropsyncFiles/ideas.org" "Academic")
      "** IDEA %i%?" :prepend t :kill-buffer t)
     ("t" "TODO")
     ("tp" "Personal" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Personal") "** TODO %i%?" :prepend t :kill-buffer t)
     ("ts" "Study" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Study") "** TODO %i%?" :prepend t :kill-buffer t)
     ("tb" "Bugs" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Bugs") "** TODO %i%?" :prepend t :kill-buffer t)
     ("to" "Shopping" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Shopping") "** TODO %i%?" :prepend t :kill-buffer t)
     ("te" "Emacs" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Emacs") "** TODO %i%?" :prepend t :kill-buffer t)
     ("th" "Health" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Health") "** TODO %i%?" :prepend t :kill-buffer t)
     ("tl" "Hacking" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Hacking") "** TODO %i%?" :prepend t :kill-buffer t)
     ("tw" "Work" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Work") "** TODO %i%?" :prepend t :kill-buffer t)
     ("tn" "Nyxt" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Nyxt") "** TODO %i%?" :prepend t :kill-buffer t)
     ("tN" "Numerai" entry (file+headline "~/Dropbox/DropsyncFiles/todo.org" "Numerai") "** TODO %i%?" :prepend t :kill-buffer t)))
  :config
  (add-to-list 'org-modules 'org-habit)
  (setq org-agenda-files
        '("~/Dropbox/DropsyncFiles/todo.org"
          "~/Dropbox/projects/org/gcal/personal.org"
          "~/Dropbox/DropsyncFiles/habits.org"
          "~/Dropbox/DropsyncFiles/ideas.org")
        org-agenda-custom-commands
        '(("n" "Next"
           ((alltodo "To-Do"
                     ((org-agenda-overriding-header "")
                      (org-agenda-remove-tags t)
                      (org-super-agenda-groups '((:name " ⚡ Next " :todo "NEXT" :discard (:anything t))))))))
          ("o" "Personal Agenda"
           ((agenda "Agenda"
                    ((org-agenda-span 5)
                     (org-agenda-overriding-header "\n ⚡ Agenda")
                     (org-agenda-remove-tags t)
                     (org-super-agenda-groups
                      '((:name "Today" :time-grid t :habit t :date today :category "personal" :discard (:anything t) :order 5))))))))))
  (setq org-agenda-sticky nil
        org-agenda-start-day nil
        org-agenda-span 1
        org-agenda-start-on-weekday nil
        org-agenda-compact-blocks t
        org-habit-show-all-today t
        org-habit-today-glyph ?⚡
        org-habit-completed-glyph ?+))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (global-org-modern-mode 1))

(use-package org-super-agenda
  :after org
  :config
  (org-super-agenda-mode 1))

(provide 'module-org)
;;; module-org.el ends here

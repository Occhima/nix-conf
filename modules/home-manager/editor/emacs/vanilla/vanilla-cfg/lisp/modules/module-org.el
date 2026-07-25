;;; module-org.el --- Org capture and agenda workflow -*- lexical-binding: t; -*-

(defconst occhima/org-todo-file
  "~/Dropbox/DropsyncFiles/todo.org")

(defun occhima/org-todo-capture-template (key headline)
  "Build an Org capture template for KEY under HEADLINE."
  `(,key ,headline entry
    (file+headline ,occhima/org-todo-file ,headline)
    "** TODO %i%?"
    :prepend t
    :kill-buffer t))

(use-package org
  :ensure nil
  :hook (org-mode . visual-line-mode)
  :custom
  (org-directory "~/Dropbox/projects/org")
  (org-tags-column -80)
  (org-use-property-inheritance t)
  (org-hide-emphasis-markers t)
  (org-enforce-todo-dependencies t)
  (org-enforce-todo-checkbox-dependencies t)
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-log-state-notes-into-drawer t)
  (org-log-repeat 'time)
  (org-todo-repeat-to-state "TODO")
  (org-todo-keywords
   '((sequence
      "TODO(t)" "PROJ(p)" "TO-READ(r)" "STRT(s)" "WAIT(w)"
      "HOLD(h)" "NEXT(n)" "IDEA(i)"
      "|"
      "DONE(d!)" "KILL(k@!)")))
  :config
  (add-to-list 'org-modules 'org-habit)
  (setq org-capture-templates
        (append
         '(("f" "Finance")
           ("fc" "Credit Card" entry
            (file+headline
             "~/Dropbox/projects/finance/finance-2023.beancount"
             "Credit-Cards")
            "** IDEA %i%?"
            :prepend t
            :kill-buffer t)
           ("i" "IDEA")
           ("ia" "Academic" entry
            (file+headline "~/Dropbox/DropsyncFiles/ideas.org" "Academic")
            "** IDEA %i%?"
            :prepend t
            :kill-buffer t)
           ("t" "TODO"))
         (mapcar
          (lambda (spec)
            (apply #'occhima/org-todo-capture-template spec))
          '(("tp" "Personal")
            ("ts" "Study")
            ("tb" "Bugs")
            ("to" "Shopping")
            ("te" "Emacs")
            ("th" "Health")
            ("tl" "Hacking")
            ("tw" "Work")
            ("tn" "Nyxt")
            ("tN" "Numerai"))))))

(use-package corg
  :ensure (corg :host github :repo "isamert/corg.el")
  :hook (org-mode . corg-setup))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (global-org-modern-mode 1))

(use-package org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode 1)
  (setq org-agenda-files
        '("~/Dropbox/DropsyncFiles/todo.org"
          "~/Dropbox/projects/org/gcal/personal.org"
          "~/Dropbox/DropsyncFiles/habits.org"
          "~/Dropbox/DropsyncFiles/ideas.org")
        org-agenda-skip-scheduled-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-day nil
        org-agenda-span 1
        org-agenda-start-on-weekday nil
        org-habit-show-all-today t
        org-habit-today-glyph ?⚡
        org-habit-completed-glyph ?+
        org-super-agenda-unmatched-name "⚡ Backlog"
        org-super-agenda-unmatched-order 50
        org-agenda-custom-commands
        '(("n" "Next"
           ((alltodo "To-Do"
             ((org-agenda-overriding-header "")
              (org-agenda-remove-tags t)
              (org-super-agenda-groups
               '((:name "⚡ Next"
                  :todo "NEXT"
                  :discard (:anything t))))))))
          ("c" "Todos"
           ((alltodo "To-Do"
             ((org-agenda-overriding-header "")
              (org-agenda-remove-tags t)
              (org-super-agenda-groups
               '((:name "❗ Important" :priority "A")
                 (:name "🌐 Nyxt" :tag "nyxt")
                 (:name "🎯 Goals" :tag "goals")
                 (:name "👷 Personal"
                  :and (:tag "personal" :todo "TODO"))
                 (:name "💰 Numerai"
                  :and (:tag "numerai" :todo "TODO"))
                 (:name "📚 Study"
                  :and (:tag "study" :todo "TODO"))
                 (:name "🐛 Bugs"
                  :and (:tag "bugs" :todo "TODO"))
                 (:name "🏢 Work"
                  :and (:tag "work" :todo "TODO"))
                 (:name "💾 Emacs"
                  :and (:tag "emacs" :todo "TODO"))
                 (:name "🩺 Health"
                  :and (:tag "health" :todo "TODO"))
                 (:name "💻 Hacking"
                  :and (:tag "hacking" :todo "TODO"))
                 (:name "📖 Books"
                  :and (:tag "books" :todo "TO-READ")
                  :order 1)
                 (:name "🛒 Shopping"
                  :and (:tag "shopping" :todo "TODO")
                  :order 1)
                 (:name "⛔ On hold"
                  :todo "HOLD"
                  :discard (:anything t)
                  :order 10)))))))
          ("o" "Personal Agenda"
           ((agenda "Agenda"
             ((org-agenda-span 5)
              (org-agenda-skip-scheduled-if-done t)
              (org-agenda-skip-timestamp-if-done t)
              (org-habit-show-all-today t)
              (org-agenda-skip-deadline-if-done t)
              (org-agenda-overriding-header "\n⚡ Agenda")
              (org-agenda-remove-tags t)
              (org-super-agenda-groups
               '((:name "Today"
                  :time-grid t
                  :habit t
                  :date today
                  :category "personal"
                  :discard (:anything t)
                  :order 5))))))))))

(provide 'module-org)
;;; module-org.el ends here

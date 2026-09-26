;;; module-org.el --- Org capture and agenda workflow -*- lexical-binding: t; -*-

(require 'core-evil)

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

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (evil-org-set-key-theme '(navigation insert textobjects additional calendar))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-crypt
  :ensure nil
  :after org
  :custom
  (org-crypt-key user-mail-address)
  :config
  (org-crypt-use-before-save-magic)
  (add-to-list 'org-tags-exclude-from-inheritance "crypt"))

(use-package org-noter
  :commands org-noter
  :custom
  (org-noter-notes-search-path (list occhima/org-roam-directory))
  (org-noter-auto-save-last-location t))

(use-package ox-pandoc
  :after ox)

(use-package toc-org
  :hook (org-mode . toc-org-mode))

(use-package org-cliplink
  :commands org-cliplink)

(occhima/local-leader org-mode
  "#" '(org-update-statistics-cookies :wk "Update cookies")
  "'" '(org-edit-special :wk "Edit special")
  "*" '(org-ctrl-c-star :wk "Toggle heading")
  "-" '(org-ctrl-c-minus :wk "Toggle item")
  "," '(org-switchb :wk "Switch org buffer")
  "." '(consult-org-heading :wk "Goto heading")
  "/" '(consult-org-agenda :wk "Goto agenda heading")
  "@" '(org-cite-insert :wk "Insert citation")
  "A" '(org-archive-subtree-default :wk "Archive subtree")
  "D" '(occhima/delete-all-org-buffers :wk "Kill Org buffers")
  "e" '(org-export-dispatch :wk "Export")
  "f" '(org-footnote-action :wk "Footnote")
  "h" '(org-toggle-heading :wk "Toggle heading")
  "i" '(org-toggle-item :wk "Toggle item")
  "I" '(org-id-get-create :wk "Create ID")
  "k" '(org-babel-remove-result :wk "Remove result")
  "n" '(org-store-link :wk "Store link")
  "o" '(org-set-property :wk "Set property")
  "q" '(org-set-tags-command :wk "Set tags")
  "t" '(org-todo :wk "Todo")
  "T" '(org-todo-list :wk "Todo list")
  "x" '(org-toggle-checkbox :wk "Toggle checkbox")
  "a" '(:ignore t :wk "attachments")
  "a a" '(org-attach :wk "Attach")
  "a d" '(org-attach-delete-one :wk "Delete one")
  "a D" '(org-attach-delete-all :wk "Delete all")
  "a n" '(org-attach-new :wk "New")
  "a o" '(org-attach-open :wk "Open")
  "a r" '(org-attach-reveal :wk "Reveal")
  "a u" '(org-attach-url :wk "From URL")
  "a s" '(org-attach-set-directory :wk "Set directory")
  "a S" '(org-attach-sync :wk "Sync")
  "b" '(:ignore t :wk "tables")
  "b -" '(org-table-insert-hline :wk "Insert hline")
  "b a" '(org-table-align :wk "Align")
  "b b" '(org-table-blank-field :wk "Blank field")
  "b c" '(org-table-create-or-convert-from-region :wk "Create/convert")
  "b e" '(org-table-edit-field :wk "Edit field")
  "b f" '(org-table-edit-formulas :wk "Edit formulas")
  "b h" '(org-table-field-info :wk "Field info")
  "b s" '(org-table-sort-lines :wk "Sort lines")
  "b r" '(org-table-recalculate :wk "Recalculate")
  "b R" '(org-table-recalculate-buffer-tables :wk "Recalculate all")
  "b d c" '(org-table-delete-column :wk "Delete column")
  "b d r" '(org-table-kill-row :wk "Delete row")
  "b i c" '(org-table-insert-column :wk "Insert column")
  "b i h" '(org-table-insert-hline :wk "Insert hline")
  "b i r" '(org-table-insert-row :wk "Insert row")
  "b i H" '(org-table-hline-and-move :wk "Hline and move")
  "b p" '(org-plot/gnuplot :wk "Plot")
  "c" '(:ignore t :wk "clock")
  "c c" '(org-clock-cancel :wk "Cancel")
  "c d" '(org-clock-mark-default-task :wk "Default task")
  "c e" '(org-clock-modify-effort-estimate :wk "Modify effort")
  "c E" '(org-set-effort :wk "Set effort")
  "c g" '(org-clock-goto :wk "Goto clock")
  "c i" '(org-clock-in :wk "Clock in")
  "c I" '(org-clock-in-last :wk "Clock in last")
  "c o" '(org-clock-out :wk "Clock out")
  "c r" '(org-resolve-clocks :wk "Resolve")
  "c R" '(org-clock-report :wk "Report")
  "c t" '(org-evaluate-time-range :wk "Time range")
  "c =" '(org-clock-timestamps-up :wk "Timestamps up")
  "c -" '(org-clock-timestamps-down :wk "Timestamps down")
  "d" '(:ignore t :wk "date/deadline")
  "d d" '(org-deadline :wk "Deadline")
  "d s" '(org-schedule :wk "Schedule")
  "d t" '(org-time-stamp :wk "Timestamp")
  "d T" '(org-time-stamp-inactive :wk "Inactive timestamp")
  "g" '(:ignore t :wk "goto")
  "g g" '(consult-org-heading :wk "Heading")
  "g G" '(consult-org-agenda :wk "Agenda heading")
  "g c" '(org-clock-goto :wk "Clock")
  "g i" '(org-id-goto :wk "ID")
  "g r" '(org-refile-goto-last-stored :wk "Last refile")
  "g x" '(org-capture-goto-last-stored :wk "Last capture")
  "l" '(:ignore t :wk "links")
  "l c" '(org-cliplink :wk "Cliplink")
  "l i" '(org-id-store-link :wk "Store ID link")
  "l l" '(org-insert-link :wk "Insert link")
  "l L" '(org-insert-all-links :wk "Insert all links")
  "l s" '(org-store-link :wk "Store link")
  "l S" '(org-insert-last-stored-link :wk "Insert last stored")
  "l t" '(org-toggle-link-display :wk "Toggle display")
  "P" '(:ignore t :wk "publish")
  "P a" '(org-publish-all :wk "All")
  "P f" '(org-publish-current-file :wk "Current file")
  "P p" '(org-publish :wk "Publish")
  "P P" '(org-publish-current-project :wk "Current project")
  "p" '(:ignore t :wk "priority")
  "p d" '(org-priority-down :wk "Down")
  "p p" '(org-priority :wk "Set")
  "p u" '(org-priority-up :wk "Up")
  "r" '(:ignore t :wk "refile")
  "r r" '(org-refile :wk "Refile")
  "r R" '(org-refile-reverse :wk "Refile reverse")
  "r ." '(org-refile-copy :wk "Refile copy")
  "s" '(:ignore t :wk "tree/subtree")
  "s a" '(org-toggle-archive-tag :wk "Archive tag")
  "s b" '(org-tree-to-indirect-buffer :wk "Indirect buffer")
  "s c" '(org-clone-subtree-with-time-shift :wk "Clone with shift")
  "s d" '(org-cut-subtree :wk "Cut")
  "s h" '(org-promote-subtree :wk "Promote")
  "s j" '(org-move-subtree-down :wk "Move down")
  "s k" '(org-move-subtree-up :wk "Move up")
  "s l" '(org-demote-subtree :wk "Demote")
  "s n" '(org-narrow-to-subtree :wk "Narrow")
  "s N" '(widen :wk "Widen")
  "s r" '(org-refile :wk "Refile")
  "s s" '(org-sparse-tree :wk "Sparse tree")
  "s S" '(org-sort :wk "Sort")
  "E" '(org-encrypt-entry :wk "Encrypt entry")
  "C-e" '(org-decrypt-entry :wk "Decrypt entry"))

(occhima/local-leader org-agenda-mode
  "d d" '(org-agenda-deadline :wk "Deadline")
  "d s" '(org-agenda-schedule :wk "Schedule")
  "c i" '(org-agenda-clock-in :wk "Clock in")
  "c o" '(org-agenda-clock-out :wk "Clock out")
  "c c" '(org-agenda-clock-cancel :wk "Clock cancel")
  "c g" '(org-agenda-clock-goto :wk "Clock goto")
  "p" '(org-agenda-priority :wk "Priority")
  "q" '(org-agenda-set-tags :wk "Set tags")
  "r" '(org-agenda-refile :wk "Refile")
  "t" '(org-agenda-todo :wk "Todo"))

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

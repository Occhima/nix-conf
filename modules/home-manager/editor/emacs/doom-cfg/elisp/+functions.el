
(defun occhima/my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:ical-create-source "Feriados Nacionais" "https://calendar.google.com/calendar/ical/pt-br.brazilian%23holiday%40group.v.calendar.google.com/public/basic.ics" "Black")  ; other org source
    (cfw:org-create-file-source "Org" "~/Dropbox/DropsyncFiles/todo.org"  "White")
    (cfw:org-create-file-source "Org Agenda" "~/Dropbox/projects/org/gcal/personal.org"  "Grey")
    )))


(defun occhima/consult-fd-choose-directory ()
  "Call `+vertico/consult-fd` with a universal prefix argument"
  (interactive)
  (let ((current-prefix-arg '(4))) ; Set the universal prefix argument
    (call-interactively '+vertico/consult-fd)))


(defun occhima/+vertico-consult-fd ()
  "Call `+vertico/consult-fd`from / directory.
If called with a universal argument choose a instead."
  (interactive)
  (if current-prefix-arg
      (occhima/consult-fd-choose-directory)
    (+vertico/consult-fd "~/")))


(defun occhima/delete-all-org-buffers  ()

  "Close all open Org-mode buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'org-mode)
        (kill-buffer buffer)))))

(map! :localleader :n "o" #'occhima/my-open-calendar
      "d" #'occhima/delete-all-org-buffers
      )

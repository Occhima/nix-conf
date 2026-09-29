;;; module-ui.el --- Workspaces, popups, zen, and help -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-close-button-show nil)
  (tab-bar-new-button-show nil)
  (tab-bar-new-tab-choice "*scratch*")
  (tab-bar-tab-hints t)
  :config
  (tab-bar-mode 1)
  (tab-bar-history-mode 1))

;; Switching project opens or reuses a tab group named after it, like Doom's
;; `+workspaces-on-switch-project-behavior'.
(use-package project-tab-groups
  :demand t
  :config
  (project-tab-groups-mode 1))

(use-package popper
  :demand t
  :custom
  (popper-reference-buffers
   '("\\*Messages\\*"
     "\\*Warnings\\*"
     "\\*Backtrace\\*"
     "Output\\*$"
     "\\*Async Shell Command\\*"
     "\\*Compile-Log\\*"
     "\\*eldoc"
     "\\*Flymake diagnostics"
     "\\*xref\\*"
     "\\*Ibuffer\\*"
     "\\*Python\\*"
     "\\*sly-mrepl"
     "\\*R\\*"
     help-mode
     helpful-mode
     compilation-mode
     justl-compile-mode))
  (popper-window-height 0.33)
  :config
  (popper-mode 1)
  (popper-echo-mode 1))

(use-package helpful
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-command] . helpful-command)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key] . helpful-key)
         ([remap describe-symbol] . helpful-symbol)))

(use-package link-hint
  :commands (link-hint-open-link link-hint-copy-link))

(use-package indent-bars
  :commands indent-bars-mode)

(use-package devdocs
  :commands (devdocs-lookup devdocs-search devdocs-install))

(use-package powerthesaurus
  :commands powerthesaurus-lookup-synonyms-dwim)

(use-package hl-todo
  :hook ((prog-mode text-mode conf-mode) . hl-todo-mode)
  :custom
  (hl-todo-highlight-punctuation ":"))

(use-package writeroom-mode
  :commands (writeroom-mode global-writeroom-mode)
  :custom
  (writeroom-width 100)
  (writeroom-mode-line t)
  (writeroom-maximize-window nil)
  (writeroom-fullscreen-effect 'maximized))

(use-package mixed-pitch
  :hook (writeroom-mode . occhima/zen-mixed-pitch)
  :init
  (defun occhima/zen-mixed-pitch ()
    "Use variable pitch text while zen mode is on."
    (mixed-pitch-mode (if writeroom-mode 1 -1))))

(defun occhima/zen-fullscreen ()
  "Toggle zen mode together with frame fullscreen."
  (interactive)
  (let ((writeroom-fullscreen-effect 'fullboth))
    (writeroom-mode 'toggle)))

(use-package ligature
  :hook (prog-mode . ligature-mode)
  :config
  (ligature-set-ligatures
   'prog-mode
   '("<---" "<--" "<<-" "<-" "->" "-->" "--->" "<->" "<-->" "<--->"
     "<!--" "<==" "<===" "<=" "=>" "=>>" "==>" "===>" "<=>" "<==>"
     ">=" "==" "===" "!=" "!==" "=/=" "::" ":::" "++" "+++" "//" "///"
     "&&" "||" "|>" "<|" "<|>" ".." "..." "..<" "<>" "</" "/>" "</>"
     "~~" "~>" "<~" "##" "###" ";;" "**" "***" "-<" ">-" "<<" ">>")))

(occhima/leader
  "~" '(popper-toggle :wk "Toggle last popup")
  "t z" '(writeroom-mode :wk "Zen mode")
  "t Z" '(occhima/zen-fullscreen :wk "Zen mode (fullscreen)")
  "s u" '(vundo :wk "Undo history"))

(general-def
  "C-`" #'popper-cycle
  "M-`" #'popper-toggle-type)

(provide 'module-ui)
;;; module-ui.el ends here

;;; module-ai.el --- Agent and coding-assistant integrations -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package acp
  :ensure (acp :host github :repo "xenodium/acp.el")
  :defer t)

(use-package shell-maker
  :defer t)

(use-package agent-shell
  :commands (agent-shell-new-shell
             agent-shell-opencode-start-agent
             agent-shell-toggle)
  :custom
  (agent-shell-preferred-agent-config 'opencode)
  (agent-shell-display-action
   '((display-buffer-in-side-window)
     (side . right)
     (window-width . 0.4))))

(use-package agent-shell-bookmark
  :ensure (agent-shell-bookmark
           :host github
           :repo "dcluna/agent-shell-bookmark")
  :after agent-shell)

(use-package agent-recall
  :commands (agent-recall-browse agent-recall-resume agent-recall-search)
  :hook (agent-shell-mode . agent-recall-track-sessions)
  :custom
  (agent-recall-search-paths '("~/Dropbox/projects" "~/.config"))
  (agent-recall-search-function 'consult-ripgrep)
  (agent-recall-browse-sort 'modified-desc))

(use-package agent-shell-workspace
  :ensure (agent-shell-workspace
           :host github
           :repo "gveres/agent-shell-workspace")
  :after agent-shell)

(use-package agent-shell-sidebar
  :ensure (agent-shell-sidebar
           :host github
           :repo "cmacrae/agent-shell-sidebar")
  :after agent-shell
  :custom
  (agent-shell-sidebar-width "30%")
  (agent-shell-sidebar-position 'right)
  (agent-shell-sidebar-locked t)
  :config
  (with-eval-after-load 'agent-shell-opencode
    (setq agent-shell-sidebar-default-config
          (agent-shell-opencode-make-agent-config))))

(occhima/leader
  "O" '(:ignore t :wk "opencode")
  "OO" '(agent-shell-opencode-start-agent :wk "Start")
  "Oo" '(agent-shell-toggle :wk "Toggle")
  "On" '(agent-shell-new-shell :wk "New shell")
  "Or" '(agent-recall-search :wk "Recall search")
  "Ob" '(agent-recall-browse :wk "Recall browse")
  "OR" '(agent-recall-resume :wk "Recall resume")
  "Ow" '(agent-shell-workspace-toggle :wk "Workspace")
  "Os" '(agent-shell-sidebar-toggle :wk "Sidebar")
  "Of" '(agent-shell-sidebar-toggle-focus :wk "Sidebar focus"))

(provide 'module-ai)
;;; module-ai.el ends here

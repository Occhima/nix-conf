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
     (window-width . 0.4)))
  :config
  (occhima/leader
    "OO" '(agent-shell-opencode-start-agent :wk "Start")
    "Oo" '(agent-shell-toggle :wk "Toggle")
    "On" '(agent-shell-new-shell :wk "New shell")))

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
  (agent-recall-browse-sort 'modified-desc)
  :config
  (occhima/leader
    "Or" '(agent-recall-search :wk "Recall search")
    "Ob" '(agent-recall-browse :wk "Recall browse")
    "OR" '(agent-recall-resume :wk "Recall resume")))

(use-package agent-shell-workspace
  :ensure (agent-shell-workspace
           :host github
           :repo "gveres/agent-shell-workspace")
  :after agent-shell
  :config
  (occhima/leader
    "Ow" '(agent-shell-workspace-toggle :wk "Workspace")))

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
          (agent-shell-opencode-make-agent-config)))
  (occhima/leader
    "Os" '(agent-shell-sidebar-toggle :wk "Sidebar")
    "Of" '(agent-shell-sidebar-toggle-focus :wk "Sidebar focus")))

(use-package claude-code
  :ensure (claude-code
           :host github
           :repo "stevemolitor/claude-code.el"
           :branch "main"
           :depth 1
           :files ("*.el" (:exclude "images/*")))
  :commands claude-code-transient-menu
  :custom
  (claude-code-terminal-backend 'vterm)
  (claude-code-display-window-fn
   (lambda (buffer)
     (display-buffer
      buffer
      '((display-buffer-in-side-window)
        (side . right)
        (window-width . 0.4)))))
  :config
  (occhima/leader
    "C" '(claude-code-transient-menu :wk "Claude Code")))

(use-package monet
  :ensure (monet :host github :repo "stevemolitor/monet")
  :after claude-code
  :config
  (add-hook 'claude-code-process-environment-functions
            #'monet-start-server-function)
  (monet-mode 1))

(provide 'module-ai)
;;; module-ai.el ends here

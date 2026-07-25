;;; +ai.el -*- lexical-binding: t; -*-

(use-package! agent-shell
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
  (map! :leader
        :prefix ("O" . "opencode")
        :desc "Start" "O" #'agent-shell-opencode-start-agent
        :desc "Toggle" "o" #'agent-shell-toggle
        :desc "New shell" "n" #'agent-shell-new-shell))

(use-package! agent-shell-bookmark
  :after agent-shell)

(use-package! agent-recall
  :commands (agent-recall-browse agent-recall-resume agent-recall-search)
  :hook (agent-shell-mode . agent-recall-track-sessions)
  :custom
  (agent-recall-search-paths '("~/Dropbox/projects" "~/.config"))
  (agent-recall-search-function 'consult-ripgrep)
  (agent-recall-browse-sort 'modified-desc)
  :config
  (map! :leader
        :prefix "O"
        :desc "Recall search" "r" #'agent-recall-search
        :desc "Recall browse" "b" #'agent-recall-browse
        :desc "Recall resume" "R" #'agent-recall-resume))

(use-package! agent-shell-workspace
  :after agent-shell
  :config
  (map! :leader
        :prefix "O"
        :desc "Workspace" "w" #'agent-shell-workspace-toggle))

(use-package! agent-shell-sidebar
  :after agent-shell
  :custom
  (agent-shell-sidebar-width "30%")
  (agent-shell-sidebar-position 'right)
  (agent-shell-sidebar-locked t)
  :config
  (with-eval-after-load 'agent-shell-opencode
    (setq agent-shell-sidebar-default-config
          (agent-shell-opencode-make-agent-config)))
  (map! :leader
        :prefix "O"
        :desc "Sidebar" "s" #'agent-shell-sidebar-toggle
        :desc "Sidebar focus" "f" #'agent-shell-sidebar-toggle-focus))

(use-package! monet
  :defer t
  :init
  (with-eval-after-load 'claude-code
    (require 'monet)
    (add-hook 'claude-code-process-environment-functions
              #'monet-start-server-function)
    (monet-mode 1)))

(use-package! claude-code
  :commands claude-code-transient-menu
  :custom
  (claude-code-terminal-backend 'vterm)
  (claude-code-display-window-fn
   (lambda (buffer)
     (display-buffer buffer
                     '((display-buffer-in-side-window)
                       (side . right)
                       (window-width . 0.4)))))
  :config
  (map! :leader
        :desc "Claude Code" "C" #'claude-code-transient-menu))

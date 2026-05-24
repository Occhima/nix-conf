(use-package! copilot
  :defer t
  :bind (
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))


(use-package! chatgpt-shell
  :defer t
  )

(use-package! khoj
  :defer t
  :if (modulep! :tools ai +khoj)
  :config
  (map!
   :localleader
   :n "k" #'khoj)
  )

(use-package! gptel
  :defer t
  ;; :if (modulep! :tools ai +khoj)
  )

(use-package! aidermacs
  :custom
  (aidermacs-use-architect-mode t)
  (aidermacs-default-model "sonnet")
  :config
  ;; Stolen from https://github.com/tninja/aider.el/blob/main/aider-doom.el
  (defun aider-doom-setup-keys ()
    (when (and (featurep 'doom-keybinds)
               (vc-backend (or (buffer-file-name) default-directory)))
      (map! :leader :n :desc "Run aidermacs" "A" #'aidermacs-transient-menu
            )
      )
    )
  (defun aider-doom-enable ()
    (interactive)
    (add-hook 'find-file-hook #'aider-doom-setup-keys)
    (add-hook 'dired-mode-hook #'aider-doom-setup-keys)
    (add-hook 'after-change-major-mode-hook #'aider-doom-setup-keys))
  (aider-doom-enable)

  )

(use-package! agent-shell
  :defer t
  :custom
  (agent-shell-preferred-agent-config 'opencode)
  (agent-shell-display-action
   '((display-buffer-in-side-window)
     (side . right)
     (window-width . 0.4)))
  :config
  (map! :leader
        :prefix ("O" . "opencode")
        :desc "Start"     "O" #'agent-shell-opencode-start-agent
        :desc "Toggle"    "o" #'agent-shell-toggle
        :desc "New shell" "n" #'agent-shell-new-shell))

(use-package! agent-shell-bookmark
  :after agent-shell)

(use-package! agent-recall
  :defer t
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
        :desc "Sidebar"       "s" #'agent-shell-sidebar-toggle
        :desc "Sidebar focus" "f" #'agent-shell-sidebar-toggle-focus))

(use-package! monet
  :defer t
  :init
  ;; Set up monet integration after claude-code loads
  (with-eval-after-load 'claude-code
    (require 'monet)
    (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
    (monet-mode 1)))

(use-package! claude-code
  :defer t
  :custom
  (claude-code-terminal-backend 'vterm)
  (claude-code-display-window-fn
   (lambda (buffer)
     "Display Claude Code buffer in a vertical split on the right."
     (display-buffer buffer
                     '((display-buffer-in-side-window)
                       (side . right)
                       (window-width . 0.4)))))
  :config
  (map! :leader
        :desc "Claude Code" "C" #'claude-code-transient-menu))

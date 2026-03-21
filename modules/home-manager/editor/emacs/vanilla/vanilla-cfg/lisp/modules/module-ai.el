;;; module-ai.el --- AI integrations (Claude Code + Monet) -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package claude-code
  :ensure (claude-code :host github :repo "stevemolitor/claude-code.el" :branch "main" :files ("*.el"))
  :commands (claude-code-transient-menu)
  :custom
  (claude-code-terminal-backend 'vterm)
  :config
  (occhima/leadrr
    "aC" #'claude-code-transient-menu))

(use-package monet
  :ensure (monet :host github :repo "stevemolitor/monet")
  :after claude-code
  :config
  (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
  (monet-mode 1))

(provide 'module-ai)
;;; module-ai.el ends here

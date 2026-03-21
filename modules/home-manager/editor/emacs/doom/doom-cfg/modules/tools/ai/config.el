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

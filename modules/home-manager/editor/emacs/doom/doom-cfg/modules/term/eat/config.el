(use-package! eat

  :demand t
  :hook (eat-mode . hide-mode-line-mode)
  :hook (eat-mode . doom-mark-buffer-as-real-h)


  :custom
  (eat-kill-buffer-on-exit t)
  (eat-shell-prompt-annotation-success-margin-indicator "")
  (eat-enable-yank-to-terminal t)
  (eat-update-semi-char-mode-map)
  :config

  (set-popup-rule! "^\\*eat" :size 0.25 :vslot -4 :select t :quit nil :ttl 0)

  (defun eat-toggle ()
    "Toggle EAT terminal.
If an EAT process exists, switch to it. Otherwise, start a new EAT session."
    (interactive)
    (let ((eat-process (cl-find-if (lambda (proc)
                                     (string-prefix-p "eat" (process-name proc)))
                                   (process-list))))
      (if eat-process
          (switch-to-buffer (process-buffer eat-process))
        (eat))))

  ;; (map! :leader
  ;;       "o t" #'eat-toggle)

  ;; For `eat-eshell-mode'.
  ;; Ac
  (add-hook 'eshell-load-hook #'eat-eshell-mode)








  )

(in-package #:nyxt-user)

(define-configuration web-buffer
  ((default-modes (cons 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration nyxt/mode/prompt-buffer:prompt-buffer-mode
  ((keyscheme-map
    (keymaps:define-keyscheme-map
      "nyxt-user-prompt" (list :import %slot-value%)
      nyxt/keyscheme:vi-normal
      (list "escape" 'nyxt/mode/prompt-buffer:quit-prompt-buffer
            "C-g" 'nyxt/mode/prompt-buffer:quit-prompt-buffer)
      nyxt/keyscheme:vi-insert
      (list "C-g" 'nyxt/mode/prompt-buffer:quit-prompt-buffer)))))

(define-configuration nyxt/mode/vi:vi-normal-mode
  ((keyscheme-map
    (keymaps:define-keyscheme-map
      "nyxt-user-vi" (list :import %slot-value%)
      nyxt/keyscheme:vi-normal
      (list
       "o" 'set-url
       "t" 'set-url-new-buffer
       "b" 'switch-buffer
       "x" 'delete-current-buffer
       "r" 'reload-current-buffer
       "H" 'history-backwards
       "L" 'history-forwards
       "J" 'switch-buffer-next
       "K" 'switch-buffer-previous
       "f" 'nyxt/mode/hint:follow-hint
       "F" 'nyxt/mode/hint:follow-hint-new-buffer
       "/" 'nyxt/mode/search-buffer:search-buffer
       "y u" 'copy-url
       ":" 'execute-command
       "g s" 'start-page
       "g e" 'open-in-emacs
       "g r" 'capture-in-org-roam
       "g a" 'add-arxiv-paper)))))

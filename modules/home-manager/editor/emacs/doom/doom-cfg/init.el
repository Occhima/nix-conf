;;; init.el -*- lexical-binding: t; -*-

(doom!
 :completion
 (corfu +dabbrev +icons +orderless)
 (vertico +childframe +icons)

 :ui
 doom
 dashboard
 doom-quit
 (emoji +ascii +github +unicode)
 hl-todo
 ligatures
 modeline
 (popup +defaults)
 unicode
 (vc-gutter +pretty)
 workspaces
 zen

 :editor
 (evil +everywhere)
 fold
 (format +onsave)
 word-wrap

 :emacs
 (dired +dirvish +icons)
 electric
 eww
 (ibuffer +icons)
 undo
 vc

 :term
 eshell
 vterm

 :checkers
 (syntax +flymake +icons)
 grammar

 :tools
 biblio
 debugger
 direnv
 (docker +lsp)
 (eval +overlay)
 (lookup +dictionary +docsets)
 (lsp +booster +eglot)
 (magit +forge)
 make
 (pass +auth)
 pdf
 tmux
 tree-sitter
 upload

 :os
 tty

 :lang
 (beancount +lsp)
 common-lisp
 data
 emacs-lisp
 (ess +lsp)
 (go +lsp +tree-sitter)
 (haskell +lsp +tree-sitter)
 (javascript +lsp +tree-sitter)
 (json +lsp +tree-sitter)
 (julia +lsp +tree-sitter)
 (latex +cdlatex +fold +lsp)
 markdown
 (nix +lsp +tree-sitter)
 (org +crypt +jupyter +noter +pandoc +pretty +roam)
 (php +tree-sitter)
 (python +lsp +tree-sitter +uv)
 qt
 (rest +jq)
 (rust +lsp +tree-sitter)
 (scala +lsp +tree-sitter)
 (sh +lsp +powershell)
 (web +lsp +tree-sitter)
 (yaml +tree-sitter)

 :email
 (mu4e +gmail +org)

 :app
 calendar
 irc
 (rss +org)

 :config
 (default +bindings +smartparens))

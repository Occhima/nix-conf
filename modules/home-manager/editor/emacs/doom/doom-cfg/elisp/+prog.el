
(after! dirvish
  (setq dired-kill-when-opening-new-dired-buffer t
        dirvish-quick-access-entries
        `(("h" "~/"                          "Home")
          ("e" ,user-emacs-directory         "Emacs user directory")
          ("m" "~/Dropbox/projects/learning/usp/masters_degree/"                     "Masters Degree")
          ("l" "~/Dropbox/projects/library"               "Library")
          ("d" "~/Downloads/"                "Downloads")
          ("t" "~/.local/share/Trash/files/" "Trash"))))

(after! projectile
  (setq projectile-project-root-files-bottom-up '("package.json" ".projectile" ".project" ".git")
        projectile-ignored-projects '("~/.emacs.d/")
        projectile-project-search-path '("~/Dropbox/projects" ))
  (defun projectile-ignored-project-function (filepath)
    "Return t if FILEPATH is within any of `projectile-ignored-projects'"
    (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects)))
  )


(after! magit
  (setq  magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))


(after! git-gutter
  (fringe-mode 8)
  (after! git-gutter-fringe
    (fringe-mode 8))
  (setq +vc-gutter-diff-unsaved-buffer t))

(after! orderless
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless)))
        )
  )

(after! corfu
  (setq! orderless-component-separator #'orderless-escapable-split-on-space)
  )

(after! consult-gh
  ;; (add-to-list 'consult-gh-default-orgs-list "Occhima")
  (setq consult-gh-default-clone-directory "~/Dropbox/projects")
  ;; (consult-gh-embark-mode)
  )



(use-package! jinx
  ;; :hook (emacs-startup . global-jinx-mode)
  :defer t
  :bind (("M-$" . jinx-correct)
         ("C-M-$" . jinx-languages))
  )

(use-package! goggles
  :hook ((prog-mode text-mode) . goggles-mode)
  :config
  (setq-default goggles-pulse t)) ;; set to nil to disable pulsing



;; IBuffer
(set-popup-rule! "^\\*Ibuffer.*" :side 'bottom :size 0.4 :select t :ignore nil)


(after! jupyter
  (setq org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                       (:session . "py")
                                                       (:pandoc . t)
                                                       (:kernel . "python3"))
        org-babel-default-header-args:jupyter-julia  '((:async . "yes")
                                                       (:session . "jl")
                                                       (:pandoc . t)
                                                       (:kernel . "julia-kernel-1.9"))
        org-babel-default-header-args:jupyter-R      '((:async . "yes")
                                                       (:session . "r")
                                                       (:pandoc . t)
                                                       (:kernel . "ir"))
        org-babel-default-header-args:jupyter-Wolfram-Language '(
                                                                 (:session . "w")
                                                                 (:pandoc . t)
                                                                 (:kernel . "wolframlanguage13"))
        )
  )



;; Configure Tempel
;; TODO: Refac this use-package macro to after! macro
(use-package! tempel
  :defer t
  ;; Require trigger prefix before template name when completing.


  :init

  ;; Setup completion at point
  (defun tempel-setup-capf ()
    ;; Add the Tempel Capf to `completion-at-point-functions'.
    ;; `tempel-expand' only triggers on exact matches. Alternatively use
    ;; `tempel-complete' if you want to see all matches, but then you
    ;; should also configure `tempel-trigger-prefix', such that Tempel
    ;; does not trigger too often when you don't expect it. NOTE: We add
    ;; `tempel-expand' *before* the main programming mode Capf, such
    ;; that it will be tried first.
    (setq-local completion-at-point-functions
                (cons #'tempel-complete
                      completion-at-point-functions)))

  (add-hook 'conf-mode-hook 'tempel-setup-capf)
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf)

  ;; Optionally make the Tempel templates available to Abbrev,
  ;; either locally or globally. `expand-abbrev' is bound to C-x '.
  ;; (add-hook 'prog-mode-hook #'tempel-abbrev-mode)
  ;; (global-tempel-abbrev-mode)
  :custom
  (tempel-trigger-prefix "<")
  )


(after! eglot
  ;; (eglot-booster-mode)
  (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless)))
        eglot-connect-timeout 600))


;;; add to $DOOMDIR/config.el
(after! julia
  (setq eglot-jl-language-server-project eglot-jl-base)
  (ess-julia-mode)
  (julia-snail)
  )

(after! eshell
  (defun my-disable-eldoc-in-eshell ()
    "Disable eldoc-box-hover-mode in Eshell."
    (when (eq major-mode 'eshell-mode)
      (eldoc-mode -1)))


  (defun fancy-shell ()
    "A pretty shell with git status"
    (let* ((cwd (abbreviate-file-name (eshell/pwd)))
           (ref (magit-get-shortname "HEAD"))
           (stat (magit-file-status))
           (x-stat eshell-last-command-status)
           (git-chunk
            (if ref
                (format "%s%s%s "
                        (propertize (if stat "[" "(") 'font-lock-face (list :foreground (if stat "red" "green")))
                        (propertize ref 'font-lock-face '(:foreground "yellow"))
                        (propertize (if stat "]" ")") 'font-lock-face (list :foreground (if stat "red" "green"))))
              "")))
      (propertize
       (format "%s %s %s$ "
               (if (< 0 x-stat) (format (propertize "!%s" 'font-lock-face '(:foreground "red")) x-stat)
                 (propertize "➤" 'font-lock-face (list :foreground (if (< 0 x-stat) "red" "green"))))
               (propertize cwd 'font-lock-face '(:foreground "#45babf"))
               git-chunk)
       ;; 'read-only f
       'front-sticky   '(font-lock-face)
       'rear-nonsticky '(font-lock-face)
       )
      )
    )

  (add-hook 'eshell-mode-hook #'my-disable-eldoc-in-eshell)
  (setq eshell-prompt-function 'fancy-shell
        eshell-prompt-regexp "^[^#$\n]* [$#] "
        eshell-highlight-prompt nil
        )

  )

(after! grammarly
  (setq grammarly-username (+pass-get-secret "grammarly/username")
        grammarly-password (+pass-get-secret  "grammarly/password")
        )
  )


(after! python
  ;; (require 'combobulate)
  ;; (add-hook 'python-ts-mode-hook combobulate-mode-hook )
  (setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info"))
  (setq +python-jupyter-repl-args '("--simple-prompt"))
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode))
  (set-eglot-client! '(python-mode python-ts-mode) '("ty" "server"))
  )

(after! combobulate
  (setq combobulate-key-prefix "C-c o")
  )


(after! gumshoe
  (global-gumshoe-backtracking-mode)
  (setf gumshoe-slot-schema '(perspective time buffer position line)
        gumshoe-auto-cancel-backtracking-p nil
        )
  )

(after! haskell
  (setq haskell-interactive-popup-errors nil)
  )


;; (after! aider
;;   (setq aider-args '("--model" "r1"))
;;   (setenv "DEEPSEEK_API_KEY"  (+pass-get-secret "deepseek/api_key"))
;;   )

(after! ess-r-mode
  (require 'ess-plot)
  (ess-plot-toggle)
  )


;; nix stujff
(map! :after nix-mode
      :map nix-mode-map
      :localleader
      "f" #'nix-flake
      )

(after! nix
  (add-hook! 'nix-mode-hook (nix-prettify-mode t))
  (after! nix-repl
    (set-popup-rule! "^\\*Nix-REPL" :size 0.4 :quit nil :select t)
    (add-hook! 'nix-repl-mode-hook (nix-prettify-mode t))
    (add-hook! 'nix-repl-mode-hook
      (let ((repl-file (doom-project-expand "shell.nix")))
        (when (file-exists-p repl-file)
          (setq-local nix-repl-executable-args (list "repl" "--file" repl-file))
          (print! "Configured nix-repl file: %s" repl-file)))
      )
    )
  )

(after! lsp-nix
  (setq lsp-nix-nil-formatter ["nixpkgs-fmt"]))

(after! (:and evil nix-repl)
  (set-evil-initial-state! 'nix-repl-mode 'insert))








;; Flyover
(add-hook! 'flycheck-mode-hook #'flyover-mode)
(after! flyover
  (setq flyover-use-theme-colors t
        flyover-wrap-messages t
        )
  )

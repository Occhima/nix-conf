;;; +prog.el -*- lexical-binding: t; -*-

(after! dirvish
  (setq dired-kill-when-opening-new-dired-buffer t
        dirvish-quick-access-entries
        `(("h" "~/"                          "Home")
          ("e" ,user-emacs-directory         "Emacs user directory")
          ("m" "~/Dropbox/projects/learning/usp/masters_degree/" "Masters Degree")
          ("l" "~/Dropbox/projects/library"                      "Library")
          ("d" "~/Downloads/"                                    "Downloads")
          ("t" "~/.local/share/Trash/files/"                    "Trash"))))

(after! projectile
  (setq projectile-project-root-files-bottom-up '("package.json" ".projectile" ".project" ".git")
        projectile-ignored-projects '("~/.emacs.d/")
        projectile-project-search-path '("~/Dropbox/projects"))
  (defun projectile-ignored-project-function (filepath)
    "Return t if FILEPATH is within any of `projectile-ignored-projects'."
    (seq-some (lambda (project)
                (file-in-directory-p filepath (expand-file-name project)))
              projectile-ignored-projects)))

;; orderless-component-separator lives here; completion-category-overrides in after! eglot
(after! orderless
  (setq orderless-component-separator #'orderless-escapable-split-on-space))

(use-package! jinx
  :defer t
  :bind (("M-$"   . jinx-correct)
         ("C-M-$" . jinx-languages)))

(use-package! goggles
  :hook ((prog-mode text-mode) . goggles-mode)
  :config
  (setq-default goggles-pulse t))

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
        org-babel-default-header-args:jupyter-Wolfram-Language '((:session . "w")
                                                                 (:pandoc . t)
                                                                 (:kernel . "wolframlanguage13"))))

;; Register tempel in CAPF early so it is available before tempel itself loads
(defun +tempel-setup-capf ()
  (add-hook 'completion-at-point-functions #'tempel-complete -90 t))

(add-hook! '(conf-mode-hook prog-mode-hook text-mode-hook) #'+tempel-setup-capf)

(after! tempel
  (setq tempel-trigger-prefix "<"))

(after! eglot
  (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless)))
        eglot-connect-timeout 600))

(after! eglot-jl
  (setq eglot-jl-language-server-project eglot-jl-base))

(after! eshell
  (defun +eshell-disable-eldoc ()
    (when (eq major-mode 'eshell-mode)
      (eldoc-mode -1)))

  (defun +eshell-fancy-prompt ()
    "Eshell prompt showing cwd and git branch/status."
    (let* ((cwd    (abbreviate-file-name (eshell/pwd)))
           (ref    (magit-get-shortname "HEAD"))
           (stat   (magit-file-status))
           (xstat  eshell-last-command-status)
           (git    (if ref
                       (format "%s%s%s "
                               (propertize (if stat "[" "(")
                                           'font-lock-face `(:foreground ,(if stat "red" "green")))
                               (propertize ref 'font-lock-face '(:foreground "yellow"))
                               (propertize (if stat "]" ")")
                                           'font-lock-face `(:foreground ,(if stat "red" "green"))))
                     "")))
      (propertize
       (format "%s %s %s$ "
               (if (< 0 xstat)
                   (format (propertize "!%s" 'font-lock-face '(:foreground "red")) xstat)
                 (propertize "➤" 'font-lock-face `(:foreground ,(if (< 0 xstat) "red" "green"))))
               (propertize cwd 'font-lock-face '(:foreground "#45babf"))
               git)
       'front-sticky   '(font-lock-face)
       'rear-nonsticky '(font-lock-face))))

  (add-hook 'eshell-mode-hook #'+eshell-disable-eldoc)
  (setq eshell-prompt-function #'+eshell-fancy-prompt
        eshell-prompt-regexp   "^[^#$\n]* [$#] "
        eshell-highlight-prompt nil))

(after! python
  (setq +python-ipython-repl-args '("-i" "--simple-prompt" "--no-color-info")
        +python-jupyter-repl-args '("--simple-prompt"))
  (set-formatter! 'ruff :modes '(python-mode python-ts-mode))
  (set-eglot-client! '(python-mode python-ts-mode) '("ty" "server")))

(use-package! combobulate
  :hook ((python-ts-mode . combobulate-mode)
         (js-ts-mode     . combobulate-mode)
         (go-ts-mode     . combobulate-mode)
         (yaml-ts-mode   . combobulate-mode)
         (json-ts-mode   . combobulate-mode))
  :custom
  (combobulate-key-prefix "C-c o"))

(after! gumshoe
  (global-gumshoe-backtracking-mode 1)
  (setf gumshoe-slot-schema          '(perspective time buffer position line)
        gumshoe-auto-cancel-backtracking-p nil))

(after! haskell
  (setq haskell-interactive-popup-errors nil))

(use-package! ess-plot
  :hook (ess-r-post-run . ess-plot-on-startup-h))

(map! :after nix-mode
      :map nix-mode-map
      :localleader
      "f" #'nix-flake)

(after! nix-mode
  (add-hook 'nix-mode-hook #'nix-prettify-mode)
  (after! nix-repl
    (set-popup-rule! "^\\*Nix-REPL" :size 0.4 :quit nil :select t)
    (add-hook! 'nix-repl-mode-hook (nix-prettify-mode t))
    (add-hook! 'nix-repl-mode-hook
      (let ((repl-file (doom-project-expand "shell.nix")))
        (when (file-exists-p repl-file)
          (setq-local nix-repl-executable-args (list "repl" "--file" repl-file))
          (print! "Configured nix-repl file: %s" repl-file))))))

(after! (:and evil nix-repl)
  (set-evil-initial-state! 'nix-repl-mode 'insert))

;; Embedded language highlighting via polymode.
;; Annotate with a comment sentinel on the line before the string:
;;
;;   text =
;;     # bash / python / json / markdown
;;     ''
;;       content here
;;     '';
;;
(use-package! polymode
  :mode ("\\.nix\\'" . +poly-nix-mode)
  :config
  (define-hostmode +nix-ts-hostmode :mode 'nix-ts-mode)

  (define-innermode +nix-bash-innermode
    :mode 'bash-ts-mode
    :head-matcher "# bash\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode +nix-python-innermode
    :mode 'python-ts-mode
    :head-matcher "# python\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode +nix-lua-innermode
    :mode 'lua-ts-mode
    :head-matcher "# lua\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode +nix-json-innermode
    :mode 'json-ts-mode
    :head-matcher "# json\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-innermode +nix-markdown-innermode
    :mode 'markdown-mode
    :head-matcher "# markdown\n[ \t]*''"
    :tail-matcher "''"
    :head-mode 'host
    :tail-mode 'host)

  (define-polymode +poly-nix-mode
    :hostmode '+nix-ts-hostmode
    :innermodes '(+nix-bash-innermode
                  +nix-python-innermode
                  +nix-lua-innermode
                  +nix-json-innermode
                  +nix-markdown-innermode)))

(use-package! flyover
  :hook (flymake-mode . flyover-mode)
  :custom
  (flyover-checkers '(flymake))
  (flyover-use-theme-colors t)
  (flyover-wrap-messages t))

(defun +just/run ()
  "Open Justl at the current project root."
  (interactive)
  (let ((default-directory (or (doom-project-root) default-directory)))
    (justl)))

(use-package! just-mode
  :mode ("\\(?:J\\|j\\)ustfile\\'" "\\.just\\'")
  :config
  (map! :map just-mode-map
        :localleader
        "r" #'justl-exec-recipe
        "R" #'justl-exec-default-recipe
        "j" #'justl
        "=" #'just-format-buffer))

(use-package! justl
  :commands (justl justl-exec-recipe justl-exec-default-recipe)
  :config
  (map! :map justl-compile-mode-map
        :localleader "j" #'justl)
  (map! :leader
        (:prefix ("j" . "just")
         :desc "Open Justl" "j" #'justl
         :desc "Run recipe" "r" #'justl-exec-recipe)))

(use-package! blamer
  :config
  (global-blamer-mode 1))


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
    (or (mapcar (lambda (p) (s-starts-with-p p filepath)) projectile-ignored-projects))))

(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     ")))

(after! git-gutter
  (fringe-mode 8)
  (after! git-gutter-fringe
    (fringe-mode 8))
  (setq +vc-gutter-diff-unsaved-buffer t))

;; orderless-component-separator lives here; completion-category-overrides in after! eglot
(after! orderless
  (setq orderless-component-separator #'orderless-escapable-split-on-space))

(after! consult-gh
  (setq consult-gh-default-clone-directory "~/Dropbox/projects"))

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
  (setq-local completion-at-point-functions
              (cons #'tempel-complete completion-at-point-functions)))

(add-hook! '(conf-mode-hook prog-mode-hook text-mode-hook) #'+tempel-setup-capf)

(after! tempel
  (setq tempel-trigger-prefix "<"))

(after! eglot
  (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-mode t)
  (setq completion-category-overrides '((eglot (styles orderless))
                                        (eglot-capf (styles orderless)))
        eglot-connect-timeout 600))

(after! julia-mode
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
  (global-gumshoe-backtracking-mode)
  (setf gumshoe-slot-schema          '(perspective time buffer position line)
        gumshoe-auto-cancel-backtracking-p nil))

(after! haskell
  (setq haskell-interactive-popup-errors nil))

(after! ess-r-mode
  (require 'ess-plot)
  (ess-plot-toggle))

(map! :after nix-mode
      :map nix-mode-map
      :localleader
      "f" #'nix-flake)

(after! nix
  (add-hook! 'nix-mode-hook (nix-prettify-mode t))
  (after! nix-repl
    (set-popup-rule! "^\\*Nix-REPL" :size 0.4 :quit nil :select t)
    (add-hook! 'nix-repl-mode-hook (nix-prettify-mode t))
    (add-hook! 'nix-repl-mode-hook
      (let ((repl-file (doom-project-expand "shell.nix")))
        (when (file-exists-p repl-file)
          (setq-local nix-repl-executable-args (list "repl" "--file" repl-file))
          (print! "Configured nix-repl file: %s" repl-file))))))

(after! lsp-nix
  (setq lsp-nix-nil-formatter ["nixpkgs-fmt"]))

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
                  +nix-json-innermode
                  +nix-markdown-innermode)))

;; ;; treesit-range-rules alternative (no indirect buffers, but verbose):
;; (after! nix-ts-mode
;;   (require 'sh-script)
;;   (defvar sh-mode--treesit-settings)
;;   (setq nix-ts-mode--font-lock-settings
;;         (append nix-ts-mode--font-lock-settings
;;                 (mapcar (lambda (r) `(,(car r) t ,(nth 2 r) t))
;;                         sh-mode--treesit-settings)))
;;   (defun +nix-ts--language-at-point (point)
;;     (let* ((range nil)
;;            (lang (cl-loop
;;                   for parser in (treesit-parser-list)
;;                   do (setq range
;;                            (cl-loop
;;                             for r in (treesit-parser-included-ranges parser)
;;                             if (and (>= point (car r)) (<= point (cdr r)))
;;                             return parser))
;;                   if range return (treesit-parser-language parser))))
;;       (or lang 'nix)))
;;   (add-hook! 'nix-ts-mode-hook
;;     (setq-local treesit-range-settings
;;       (treesit-range-rules
;;         :embed 'bash :host 'nix
;;         '(((comment) @_c . (indented_string_expression (string_fragment) @capture))
;;           (:match "^#[ \t]*\\(ba\\)?sh$" @_c))
;;         :embed 'python :host 'nix
;;         '(((comment) @_c . (indented_string_expression (string_fragment) @capture))
;;           (:match "^#[ \t]*python" @_c))
;;         :embed 'json :host 'nix
;;         '(((comment) @_c . (indented_string_expression (string_fragment) @capture))
;;           (:match "^#[ \t]*json" @_c))))
;;     (setq-local treesit-language-at-point-function #'+nix-ts--language-at-point)))

(add-hook! 'flycheck-mode-hook #'flyover-mode)
(after! flyover
  (setq flyover-use-theme-colors t
        flyover-wrap-messages t))

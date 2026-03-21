;;; core-package-management.el --- Elpaca bootstrap -*- lexical-binding: t; -*-

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order
  '(elpaca :repo "https://github.com/progfolio/elpaca.git"
           :ref nil
           :files (:defaults "elpaca-test.el" (:exclude "extensions"))
           :build (:not elpaca--activate-package)))

(let* ((repo (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (if (zerop (call-process "git" nil "*elpaca-bootstrap*" t "clone"
                             (plist-get order :repo) repo))
        (progn
          (when-let ((ref (plist-get order :ref)))
            (call-process "git" nil "*elpaca-bootstrap*" t "checkout" ref))
          (let ((default-directory repo))
            (call-process (concat invocation-directory invocation-name) nil "*elpaca-bootstrap*" nil
                          "-Q" "-L" "." "--batch"
                          "--eval" "(byte-recompile-directory \".\" 0 'force)")))
      (error "Elpaca bootstrap failed; inspect *elpaca-bootstrap* buffer")))
  (require 'elpaca))

;; Keep package builds/downloads concurrent to speed up first bootstrap.
(setq elpaca-queue-limit (max 4 (if (fboundp 'num-processors) (num-processors) 4)))

(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(setq use-package-always-ensure t
      use-package-compute-statistics t)

(provide 'core-package-management)
;;; core-package-management.el ends here

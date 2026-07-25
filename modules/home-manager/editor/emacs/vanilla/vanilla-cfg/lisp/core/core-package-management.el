;;; core-package-management.el --- Elpaca bootstrap -*- lexical-binding: t; -*-

(require 'core-paths)

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory
  (expand-file-name "elpaca/" occhima/data-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order
  '(elpaca :repo "https://github.com/progfolio/elpaca.git"
           :ref nil :depth 1 :inherit ignore
           :files (:defaults "elpaca-test.el" (:exclude "extensions"))
           :build (:not elpaca-activate)))

(let* ((repo (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (condition-case-unless-debug err
        (if-let* ((buffer (get-buffer-create "*elpaca-bootstrap*"))
                  ((zerop
                    (apply #'call-process
                           `("git" nil ,buffer t "clone"
                             ,@(when-let ((depth (plist-get order :depth)))
                                 (list (format "--depth=%d" depth)
                                       "--no-single-branch"))
                             ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop
                    (call-process emacs nil buffer nil
                                  "-Q" "-L" "." "--batch"
                                  "--eval"
                                  "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (kill-buffer buffer)
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error)
       (warn "%s" err)
       (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil))
      (load "./elpaca-autoloads"))))

(setq elpaca-queue-limit (max 4 (if (fboundp 'num-processors) (num-processors) 4)))

(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca (elpaca-use-package :wait t)
  (elpaca-use-package-mode))

(setq use-package-always-ensure t
      use-package-compute-statistics t
      use-package-expand-minimally t)

(add-hook 'elpaca-after-init-hook
          (lambda ()
            (load custom-file 'noerror 'nomessage)))

(provide 'core-package-management)
;;; core-package-management.el ends here

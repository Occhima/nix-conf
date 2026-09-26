;;; module-vc-compile.el --- Magit and compile workflow -*- lexical-binding: t; -*-

(require 'core-evil)

(use-package magit
  :commands (magit-status magit-blame-addition)
  :custom
  (magit-revision-show-gravatars '(("^Author:     " . "^Commit:     "))))

(use-package forge
  :after magit)

(use-package diff-hl
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :custom
  (diff-hl-draw-borders nil)
  :config
  (global-diff-hl-mode 1)
  (diff-hl-flydiff-mode 1)
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1))
  (evil-define-key 'normal 'global
    "[d" #'diff-hl-previous-hunk
    "]d" #'diff-hl-next-hunk))

(use-package git-timemachine
  :commands git-timemachine-toggle)

(use-package git-link
  :commands (git-link git-link-homepage)
  :custom
  (git-link-open-in-browser nil))

(use-package blamer
  :custom
  (blamer-idle-time 0.5)
  :config
  (global-blamer-mode 1))

(use-package gumshoe
  :config
  (setq gumshoe-slot-schema '(time buffer position line)
        gumshoe-auto-cancel-backtracking-p nil)
  (global-gumshoe-backtracking-mode 1))

(use-package compile
  :ensure nil
  :commands (compile recompile kill-compilation)
  :custom
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-scroll-output 'first-error)
  :config
  (with-eval-after-load 'evil
    (evil-set-initial-state 'compilation-mode 'normal)))

(occhima/leader
  "g R" '(vc-revert :wk "Revert file")
  "g [" '(diff-hl-previous-hunk :wk "Previous hunk")
  "g ]" '(diff-hl-next-hunk :wk "Next hunk")
  "g r" '(diff-hl-revert-hunk :wk "Revert hunk")
  "g s" '(diff-hl-stage-dwim :wk "Stage hunk")
  "g t" '(git-timemachine-toggle :wk "Git time machine")
  "g y" '(git-link :wk "Copy link to remote")
  "g Y" '(git-link-homepage :wk "Copy link to homepage")
  "g D" '(magit-file-delete :wk "Delete file")
  "g f f" '(magit-find-file :wk "Find file")
  "g f g" '(magit-find-git-config-file :wk "Find gitconfig")
  "g f c" '(magit-show-commit :wk "Find commit")
  "g f i" '(forge-visit-issue :wk "Find issue")
  "g f p" '(forge-visit-pullreq :wk "Find pull request")
  "g o r" '(forge-browse-remote :wk "Browse remote")
  "g o c" '(forge-browse-commit :wk "Browse commit")
  "g o i" '(forge-browse-issue :wk "Browse issue")
  "g o p" '(forge-browse-pullreq :wk "Browse pull request")
  "g o I" '(forge-browse-issues :wk "Browse issues")
  "g o P" '(forge-browse-pullreqs :wk "Browse pull requests")
  "g l r" '(magit-list-repositories :wk "List repositories")
  "g l s" '(magit-list-submodules :wk "List submodules")
  "g l i" '(forge-list-issues :wk "List issues")
  "g l p" '(forge-list-pullreqs :wk "List pull requests")
  "g l n" '(forge-list-notifications :wk "List notifications")
  "g c r" '(magit-init :wk "Initialize repo")
  "g c R" '(magit-clone :wk "Clone repo")
  "g c c" '(magit-commit-create :wk "Commit")
  "g c f" '(magit-commit-fixup :wk "Fixup")
  "g c b" '(magit-branch-and-checkout :wk "Branch")
  "g c i" '(forge-create-issue :wk "Issue")
  "g c p" '(forge-create-pullreq :wk "Pull request")
  "t d" '(diff-hl-mode :wk "Diff highlights")
  "g /" '(magit-dispatch :wk "Magit dispatch")
  "g ." '(magit-file-dispatch :wk "Magit file dispatch")
  "g '" '(forge-dispatch :wk "Forge dispatch")
  "g b" '(magit-branch-checkout :wk "Switch branch")
  "g g" '(magit-status :wk "Magit status")
  "g G" '(magit-status-here :wk "Magit status here")
  "g B" '(magit-blame-addition :wk "Magit blame")
  "g C" '(magit-clone :wk "Magit clone")
  "g F" '(magit-fetch :wk "Magit fetch")
  "g L" '(magit-log-buffer-file :wk "Buffer log")
  "g S" '(magit-file-stage :wk "Stage file")
  "g U" '(magit-file-unstage :wk "Unstage file")
  "c K" '(kill-compilation :wk "Kill compilation"))

(provide 'module-vc-compile)
;;; module-vc-compile.el ends here

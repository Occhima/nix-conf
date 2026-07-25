;;; early-init.el --- Early startup tuning -*- lexical-binding: t; -*-

(add-to-list 'load-path
             (expand-file-name "lisp/core" user-emacs-directory))
(require 'core-paths)

(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln/" occhima/cache-directory)))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      package-enable-at-startup nil
      frame-inhibit-implied-resize t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(setq-default cursor-in-non-selected-windows nil)

(provide 'early-init)
;;; early-init.el ends here

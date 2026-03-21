;;; doom-oxocarbon-theme.el --- Oxocarbon for Doom Emacs -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: you
;; Maintainer: you
;;
;;; Commentary:
;; A Doom theme port of the Oxocarbon palette.
;;
;;; Code:

(require 'doom-themes)

;;
;;; Variables

(defgroup doom-oxocarbon-theme nil
  "Options for the `doom-oxocarbon' theme."
  :group 'doom-themes)

(defcustom doom-oxocarbon-brighter-comments nil
  "If non-nil, comments are slightly brighter."
  :group 'doom-oxocarbon-theme
  :type 'boolean)

(defcustom doom-oxocarbon-padded-modeline doom-themes-padded-modeline
  "If non-nil, add padding to the modeline (integer = exact px)."
  :group 'doom-oxocarbon-theme
  :type '(choice integer boolean))

;;
;;; Theme

(def-doom-theme doom-oxocarbon
  "A dark theme based on Oxocarbon."
  :family 'doom-oxocarbon
  :background-mode 'dark

  ;; ---- Palette (triplets: GUI / 256 / tty) ----
  (
   ;; Core ramp (from bg → fg)
   (base-00 '("#131313" "#121212" "black"))    ; base (darker)
   (base-0  '("#161616" "#161616" "black"))    ; surface
   (base-1  '("#21202e" "#1e1e1e" "black"))
   (base-2  '("#262626" "#262626" "brightblack"))
   (base-3  '("#292929" "#2a2a2a" "brightblack"))
   (base-4  '("#363636" "#3a3a3a" "brightblack"))
   (base-5  '("#525252" "#525252" "brightblack"))
   (base-6  '("#bbc1c6" "#bcbcbc" "white"))
   (base-7  '("#dde1e6" "#d7d7d7" "white"))
   (base-8  '("#ffffff" "#ffffff" "white"))

   ;; Named accents from your autothemer palette
   (iris      '("#be95ff" "#afafff" "brightmagenta"))
   (foam      '("#82cfff" "#87d7ff" "brightblue"))
   (green     '("#42be65" "#5fd787" "green"))
   (pine      '("#08bdba" "#00ffff" "cyan"))
   (rose      '("#f5e0dc" "#ffd7d7" "white"))
   (gold      '("#f6c177" "#ffd7af" "yellow"))
   (pink      '("#FF74B8" "#ff87d7" "brightmagenta"))
   (love      '("#FF0065" "#ff005f" "red"))

   ;; Canonical Doom slots
   (bg        base-0)
   (bg-alt    base-00)
   (fg        base-8)
   (fg-alt    base-7)

   (base0 base-00)
   (base1 base-0)
   (base2 base-2)
   (base3 base-3)
   (base4 base-4)
   (base5 base-5)
   (base6 base-6)
   (base7 base-7)
   (base8 base-8)

   (grey        base-5)
   (red         love)
   (orange      gold)
   (yellow      gold)
   (green*      green)
   (teal        pine)
   (blue        foam)
   (dark-blue   foam)
   (magenta     pink)
   (violet      iris)
   (cyan        pine)
   (dark-cyan   pine)

   ;; Universal syntax classes (required by doom-themes)
   (highlight      base-2)
   (vertical-bar   (doom-darken bg 0.10))
   (selection      (doom-lighten base-2 0.02))
   (builtin        iris)
   (comments       (if doom-oxocarbon-brighter-comments base-6 base-5))
   (doc-comments   (doom-blend comments fg 0.5))
   (constants      gold)
   (functions      foam)
   (keywords       pink)
   (methods        foam)
   (operators      pine)
   (type           iris)
   (strings        gold)
   (variables      rose)
   (numbers        gold)
   (region         (doom-lighten bg-alt 0.06))
   (error          love)
   (warning        gold)
   (success        pine)
   (vc-modified    rose)
   (vc-added       pine)
   (vc-deleted     love)

   ;; Modeline helpers (compute directly from slots; no car/cdr)
   (modeline-fg-alt (doom-blend fg bg-alt 0.6))
   (modeline-bg     (doom-lighten bg 0.05))
   (modeline-bg-alt (doom-darken  bg 0.02))
   (-modeline-pad
    (when doom-oxocarbon-padded-modeline
      (if (integerp doom-oxocarbon-padded-modeline) doom-oxocarbon-padded-modeline 4)))
  )

  ;; ---- Base face overrides ----
  (
   ;; Core UI
   ((cursor &override) :background pine)
   (shadow :foreground base-5)
   ((line-number &override) :foreground base-4)
   ((line-number-current-line &override) :foreground iris :background base-3 :weight 'bold)
   (link :foreground foam :underline t)
   (highlight :background (doom-blend bg blue 0.4) :distant-foreground fg-alt)

   ;; Region/search
   (region :background (doom-lighten bg-alt 0.06))
   (isearch        :background gold :foreground base-00 :weight 'bold)
   (lazy-highlight :background foam :foreground base-00)
   (match          :background gold :foreground base-00 :weight 'bold)

   ;; Modeline
   (mode-line
    :background modeline-bg :foreground fg
    :box (when -modeline-pad `(:line-width ,(- -modeline-pad) :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-alt :foreground base-4
    :box (when -modeline-pad `(:line-width ,(- -modeline-pad) :color ,modeline-bg-alt)))
   (mode-line-emphasis :foreground rose)
   (doom-modeline-bar :background gold)
   (doom-modeline-buffer-file :foreground fg :weight 'bold)
   (doom-modeline-buffer-major-mode :foreground rose :weight 'bold)
   (doom-modeline-buffer-modified :foreground fg :slant 'italic :weight 'bold)

   ;; Syntax
   ((font-lock-comment-face &override) :slant 'italic :foreground comments)
   (font-lock-doc-face :foreground comments)
   (font-lock-string-face :foreground gold :slant 'italic)
   (font-lock-constant-face :foreground gold :weight 'bold)
   (font-lock-keyword-face :foreground pink :weight 'semibold)
   (font-lock-type-face :foreground iris :weight 'semibold)
   (font-lock-builtin-face :foreground iris)
   (font-lock-function-name-face :foreground foam)
   (font-lock-variable-name-face :foreground rose)
   (font-lock-warning-face :foreground gold)

   ;; Parens & delimiters
   (show-paren-match    :background rose :foreground base-00 :weight 'bold)
   (show-paren-mismatch :background love :foreground base-00 :weight 'bold)

   ;; Org
   (org-ellipsis :foreground base-5 :weight 'bold)
   (org-code     :background base-00)
   (org-block    :background base-00)
   (org-block-begin-line :background base-00 :foreground base-5)
   (org-block-end-line   :background base-00 :foreground base-5)
   (org-done     :foreground base-5)
   (org-todo     :foreground pine :weight 'bold)
   (org-level-1  :foreground love :height 1.3 :weight 'bold)
   (org-level-2  :foreground iris :height 1.15 :weight 'bold)
   (org-level-3  :foreground rose :height 1.05)
   (org-level-4  :foreground fg)

   ;; Rainbow-delimiters
   (rainbow-delimiters-base-face (:foreground base-5))
   (rainbow-delimiters-depth-1-face (:foreground pine))
   (rainbow-delimiters-depth-2-face (:foreground pink))
   (rainbow-delimiters-depth-3-face (:foreground love))
   (rainbow-delimiters-depth-4-face (:foreground foam))
   (rainbow-delimiters-depth-5-face (:foreground iris))
   (rainbow-delimiters-depth-6-face (:foreground base-7))
   (rainbow-delimiters-depth-7-face (:foreground base-5))
   (rainbow-delimiters-depth-8-face (:foreground gold))
   (rainbow-delimiters-depth-9-face (:foreground iris))
   (rainbow-delimiters-unmatched-face :foreground base-00 :background love :weight 'bold)

   ;; Diff
   (diff-added   :background (doom-blend pine bg 0.85) :foreground fg)
   (diff-removed :background (doom-blend love bg 0.85) :foreground fg)
   (diff-changed :background (doom-blend gold bg 0.85) :foreground base-00)

   ;; Completions / Company (generic)
   (company-tooltip :background base-3 :foreground fg)
   (company-tooltip-selection :background base-3 :underline t :weight 'bold)
   (company-scrollbar-bg :background base-3)
   (company-scrollbar-fg :background love)
   (completions-annotations :foreground base-5 :slant 'italic)

   ;; Treemacs
   (treemacs-directory-face :foreground base-7)
   (treemacs-file-face :foreground base-7)
   (treemacs-fringe-indicator-face :foreground love)
   (treemacs-git-modified-face :foreground rose)
   (treemacs-git-added-face :foreground gold)
   (treemacs-git-ignored-face :foreground base-5)
   (treemacs-git-unmodified-face :foreground fg)

   ;; Term colors
   (term :background bg :foreground fg)
   (term-color-blue    :background foam :foreground foam)
   (term-color-red     :background love :foreground love)
   (term-color-yellow  :background gold :foreground gold)
   (term-color-green   :background pine :foreground pine)
   (term-color-magenta :background iris :foreground iris)
   (term-color-cyan    :background pine :foreground pine)
  )

  ;; ---- Variables (optional) ----
  ()
)

;;; doom-oxocarbon-theme.el ends here

;;; doom-monokai-classic-theme.el --- port of Monokai Classic -*- lexical-binding: t; no-byte-compile: t; -*-
;; NOTE: Theme palette stolen from https://github.com/adamgraham/polykai
;; Added: March 12, 2020 (3767e6854429)
;; Author: ema2159 <https://github.com/ema2159>
;; Maintainer:
;; Source: https://monokai.pro
;;
;;; Commentary:
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-polykai-theme nil
  "Options for doom-molokai."
  :group 'doom-themes)

(defcustom doom-polykai-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-polykai-theme
  :type 'boolean)

(defcustom doom-polykai-comment-bg doom-polykai-brighter-comments
  "If non-nil, comments will have a subtle, darker background. Enhancing their
legibility."
  :group 'doom-polykai-theme
  :type 'boolean)

(defcustom doom-polykai-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line. Can be an integer to
determine the exact padding."
  :group 'doom-polykai-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-polykai
    "A dark, vibrant theme inspired by Textmate's Monokai."
  :family 'doom-molokai
  :background-mode 'dark

  ;; name        gui       256       16
  (
   (bg         '("#141818" nil       nil))
   (bg-alt     '("#1e2424" nil       nil))
   (base0      '("#141818" "black"   "black"))
   (base1      '("#1e2424" "#101010" "brightblack"))
   (base2      '("#3c4848" "#191919" "brightblack"))
   (base3      '("#3c4848" "#252525" "brightblack"))
   (base4      '("#909090" "#454545" "brightblack"))
   (base5      '("#909090" "#6B6B6B" "brightblack"))
   (base6      '("#f8f8f8" "#7B7B7B" "brightblack"))
   (base7      '("#f8f8f8" "#C1C1C1" "brightblack"))
   (base8      '("#f8f8f8" "#FFFFFF" "brightwhite"))
   (fg         '("#f8f8f8" "#DFDFDF" "brightwhite"))
   (fg-alt     '("#909090" "#4D4D4D" "white"))

   (grey       '("#909090" "#909090" "brightblack"))
   (red        '("#ff0060" "#ff0060" "red"))          ; base0E / 0F
   (orange     '("#ffb000" "#ffb000" "brightred"))    ; base08
   (green      '("#a0ff20" "#a0ff20" "green"))        ; base0A
   (teal       green)
   (yellow     '("#ffe080" "#ffe080" "yellow"))       ; base0B
   (blue       '("#6080ff" "#6080ff" "brightblue"))   ; base09
   (dark-blue  '("#40c4ff" "#40c4ff" "blue"))         ; base0D
   (magenta    '("#ff0060" "#ff0060" "magenta"))      ; base0E / 0F
   (violet     '("#c080ff" "#c080ff" "brightmagenta")) ; base0C
   (cyan       '("#40c4ff" "#40c4ff" "brightcyan"))   ; base0D
   (dark-cyan  '("#6080ff" "#6080ff" "cyan"))        ; dimmer blue

   ;; face categories
   (highlight      orange)
   (vertical-bar   (doom-lighten bg 0.1))
   (selection      base5)
   (builtin        orange)
   (comments       (if doom-polykai-brighter-comments violet base5))
   (doc-comments   (if doom-polykai-brighter-comments (doom-lighten violet 0.1) (doom-lighten base5 0.25)))
   (constants      violet)
   (functions      green)
   (keywords       magenta)
   (methods        green)
   (operators      magenta)
   (type           cyan)
   (strings        yellow)
   (variables      fg)
   (numbers        violet)
   (region         base4)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    cyan)
   (vc-added       (doom-darken green 0.15))
   (vc-deleted     red)

   ;; custom categories
   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-polykai-padded-modeline
      (if (integerp doom-polykai-padded-modeline) doom-polykai-padded-modeline 4)))

   (modeline-fg 'unspecified)
   (modeline-fg-alt base4)

   (modeline-bg base1)
   (modeline-bg-inactive (doom-darken base2 0.2))

   (org-quote `(,(doom-lighten (car bg) 0.05) "#1f1f1f")))


  ;;;; Base theme face overrides
  ((cursor :background magenta)
   ((font-lock-comment-face &override) :slant 'italic)
   ((font-lock-type-face &override) :slant 'italic)
   (lazy-highlight :background violet :foreground base0 :distant-foreground base0 :bold bold)
   ((line-number &override) :foreground base5 :distant-foreground nil)
   ((line-number-current-line &override) :foreground base7 :distant-foreground nil)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color modeline-bg-inactive)))

   ;;;; centaur-tabs
   (centaur-tabs-selected-modified :inherit 'centaur-tabs-selected
                                   :background bg
                                   :foreground yellow)
   (centaur-tabs-unselected-modified :inherit 'centaur-tabs-unselected
                                     :background bg-alt
                                     :foreground yellow)
   (centaur-tabs-active-bar-face :background yellow)
   (centaur-tabs-modified-marker-selected :inherit 'centaur-tabs-selected :foreground fg)
   (centaur-tabs-modified-marker-unselected :inherit 'centaur-tabs-unselected :foreground fg)
   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground keywords)
   ;;;; doom-modeline
   (doom-modeline-bar :background yellow)
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :inherit 'bold :foreground green)
   (doom-modeline-buffer-project-root :foreground green :weight 'bold)
   (doom-modeline-buffer-modified :inherit 'bold :foreground orange)


   (isearch :foreground base0 :background green)
   ;;;; ediff <built-in>
   (ediff-fine-diff-A :background (doom-blend magenta bg 0.3) :weight 'bold)
   ;;;; evil
   (evil-search-highlight-persist-highlight-face :background violet)
   ;;;; evil-snipe
   (evil-snipe-first-match-face :foreground base0 :background green)
   (evil-snipe-matches-face     :foreground green :underline t)
   ;;;; flycheck
   (flycheck-error   :underline `(:style wave :color ,red)    :background base3)
   (flycheck-warning :underline `(:style wave :color ,yellow) :background base3)
   (flycheck-info    :underline `(:style wave :color ,green)  :background base3)
   ;;;; helm
   (helm-swoop-target-line-face :foreground magenta :inverse-video t)
   ;;;; ivy
   (ivy-current-match :background base3)
   (ivy-minibuffer-match-face-1 :background base1 :foreground base4)
   ;;;; markdown-mode
   (markdown-blockquote-face :inherit 'italic :foreground dark-blue)
   (markdown-list-face :foreground magenta)
   (markdown-pre-face  :foreground cyan)
   (markdown-link-face :inherit 'bold :foreground blue)
   ((markdown-code-face &override) :background (doom-lighten base2 0.045))
   ;;;; neotree
   (neo-dir-link-face   :foreground cyan)
   (neo-expand-btn-face :foreground magenta)
   ;;;; outline <built-in>
   ((outline-1 &override) :foreground magenta)
   ((outline-2 &override) :foreground orange)
   ;;;; org <built-in>
   (org-ellipsis :foreground orange)
   (org-tag :foreground yellow :bold nil)
   ((org-quote &override) :inherit 'italic :foreground base7 :background org-quote)
   (org-todo :foreground yellow :bold 'inherit)
   (org-list-dt :foreground yellow)
   ((org-block &override) :background base2)
   ((org-block-background &override) :background base2)
   ((org-block-begin-line &override) :background base2)
   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground magenta)
   (rainbow-delimiters-depth-2-face :foreground orange)
   (rainbow-delimiters-depth-3-face :foreground green)
   (rainbow-delimiters-depth-4-face :foreground cyan)
   (rainbow-delimiters-depth-5-face :foreground magenta)
   (rainbow-delimiters-depth-6-face :foreground orange)
   (rainbow-delimiters-depth-7-face :foreground green))

  ;;;; Base theme variable overrides
  ;; ()
  )

;;; doom-polykai-theme.el ends here

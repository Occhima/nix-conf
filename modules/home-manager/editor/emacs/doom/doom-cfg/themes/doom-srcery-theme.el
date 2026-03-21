;;; doom-srcery-theme.el --- inspired by Srcery -*- no-byte-compile: t; -*-

(require 'doom-themes)

;;
;;; Variables
;;;

(defgroup doom-srcery-theme nil
  "Options for the 'doom-srcery' theme."
  :group 'doom-themes)

(defcustom doom-srcery-padded-modeline doom-themes-padded-modeline
  "If non-nil, a padded modeline is used by the 'doom-srcery' theme."
  :group 'doom-srcery-theme
  :type 'boolean)

;;
;;; Theme definition

(def-doom-theme doom-srcery
                "A dark theme based on the Srcery color scheme."

                ;; Color palette
                ((bg         '("#1C1B19"))
                 (bg-alt     '("#2D2C29"))
                 (base0      '("#3F3F3F"))
                 (base1      '("#4B474C"))
                 (base2      '("#918175"))
                 (base3      '("#2D2C29"))
                 (base4      '("#BAA67F"))
                 (base5      '("#FEFBEC"))
                 (base6      '("#FCE8C3"))
                 (base7      '("#E02C6D"))
                 (base8      '("#FF5C8F"))
                 (fg         '("#FCE8C3"))
                 (fg-alt     '("#FEFBEC"))

                 (grey       base4)
                 (red        '("#EF2F27"))
                 (orange     '("#FF5F00"))
                 (green      '("#519F50"))
                 (teal       '("#0AAEB3"))
                 (yellow     '("#FBB829"))
                 (blue       '("#2C78BF"))
                 (dark-blue  '("#2D2C29"))
                 (magenta    '("#E02C6D"))
                 (violet     '("#FF5C8F"))
                 (cyan       '("#0AAEB3"))
                 (dark-cyan  '("#2D2C29"))

                 ;; Face categories
                 (highlight      blue)
                 (vertical-bar   base1)
                 (selection      dark-blue)
                 (builtin        magenta)
                 (comments       grey)
                 (doc-comments   (doom-lighten grey 0.25))
                 (constants      violet)
                 (functions      magenta)
                 (keywords       red)
                 (methods        cyan)
                 (operators      blue)
                 (type           yellow)
                 (strings        green)
                 (variables      orange)
                 (numbers        violet)
                 (region         dark-blue)
                 (error          red)
                 (warning        yellow)
                 (success        green)
                 (vc-modified    orange)
                 (vc-added       green)
                 (vc-deleted     red)

                 )
                )

;;; doom-srcery-theme.el ends here

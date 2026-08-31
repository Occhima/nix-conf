(in-package #:nyxt-user)

(defvar *glyph-close* (string (code-char #x00D7))
  "Multiplication sign, used as the per-tab close affordance.")

(defvar *glyph-modes* (string (code-char #x2261))
  "Identical-to sign, used as the mode menu toggle.")

(defun %mono-stack (family)
  "CSS font stack falling back from FAMILY to a generic monospace face."
  (format nil "~a, 'dejavu sans mono', ui-monospace, monospace" family))

(defun %sans-stack (family)
  "CSS font stack falling back from FAMILY to a generic sans-serif face."
  (format nil "~a, 'public sans', ui-sans-serif, sans-serif" family))

(defun %hairline (color alpha)
  "COLOR mixed ALPHA (0..1) of the way towards transparency."
  (format nil "color-mix(in srgb, ~a ~a%, transparent)"
          color (round (* alpha 100))))

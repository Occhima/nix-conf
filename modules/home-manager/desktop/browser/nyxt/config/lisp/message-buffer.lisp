(in-package #:nyxt-user)

(define-configuration message-buffer
  ((height 20)
   (style
    (str:concat
     %slot-value%
     (theme:themed-css (theme *browser*)
       `(body
         :background-color ,theme:background-color
         :color ,theme:primary-color
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "12px"
         :line-height "20px"
         :letter-spacing "0.01em"
         :padding "0 12px"))))))

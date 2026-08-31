(in-package #:nyxt-user)

(define-configuration web-buffer
  ((default-modes (cons 'nyxt/mode/small-web:small-web-mode %slot-value%))
   (style
    (str:concat
     %slot-value%
     (theme:themed-css (theme *browser*)
       `(body
         :background-color ,theme:background-color
         :color ,theme:on-background-color
         :font-family ,(%sans-stack theme:font-family)
         :font-size "15px"
         :line-height "1.65"
         :padding "32px 40px 64px 40px"
         :max-width "58rem"
         :margin "0 auto")
       `("h1, h2, h3, h4, h5, h6"
         :font-family ,(%sans-stack theme:font-family)
         :font-weight "600"
         :letter-spacing "-0.015em"
         :line-height "1.25"
         :margin-top "1.8em"
         :margin-bottom "0.5em")
       '(h1 :font-size "1.9em" :margin-top "0")
       '(h2 :font-size "1.45em")
       '(h3 :font-size "1.15em")
       `(a
         :color ,theme:on-background-color
         :text-decoration "none"
         :border-bottom ,(format nil "1px solid ~a"
                                 (%hairline theme:on-background-color 0.30))
         :transition "border-color 120ms ease")
       `("a:hover"
         :border-bottom-color ,theme:on-background-color)
       `("code, pre, kbd, samp"
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "0.9em")
       `("pre, p code"
         :background-color ,theme:background-color+
         :color ,theme:on-background-color
         :border-radius "8px")
       `(pre
         :padding "14px 16px"
         :overflow-x "auto"
         :line-height "1.5"
         :border ,(format nil "1px solid ~a"
                          (%hairline theme:on-background-color 0.10)))
       '("p code, li code, td code"
         :padding "1px 5px"
         :border-radius "4px")
       `(blockquote
         :margin "1.2em 0"
         :padding "2px 0 2px 16px"
         :border-left ,(format nil "2px solid ~a"
                               (%hairline theme:on-background-color 0.25))
         :color ,theme:primary-color)
       `(hr
         :border "none"
         :height "1px"
         :margin "2em 0"
         :background-color ,(%hairline theme:on-background-color 0.10))
       '(table
         :border-radius "8px"
         :border-collapse "separate"
         :border-spacing "0"
         :overflow "hidden")
       `("table, th, td"
         :border-color ,(%hairline theme:on-background-color 0.10))
       '("td, th"
         :padding "9px 12px")
       `(th
         :background-color ,theme:background-color+
         :color ,theme:primary-color
         :font-weight "500"
         :font-size "0.8em"
         :letter-spacing "0.06em"
         :text-transform "uppercase")
       '("th:first-of-type" :border-top-left-radius "8px")
       '("th:last-of-type" :border-top-right-radius "8px")
       '("tr:last-of-type td:first-of-type" :border-bottom-left-radius "8px")
       '("tr:last-of-type td:last-of-type" :border-bottom-right-radius "8px")
       `(".mode-menu"
         :background-color ,theme:background-color
         :height "38px"
         :margin-top "-10px"
         :display "flex"
         :align-items "center"
         :gap "14px"
         :border-bottom ,(format nil "1px solid ~a"
                                 (%hairline theme:on-background-color 0.10)))
       `(".mode-menu > button"
         :height "24px"
         :margin-right "0"
         :padding "0"
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "11px"
         :border-radius "0"
         :background-color "transparent"
         :color ,theme:primary-color
         :transition "color 120ms ease")
       `(".mode-menu > .command"
         :color ,theme:on-background-color)
       `(".mode-menu > button:hover"
         :color ,theme:on-background-color
         :cursor "pointer")
       '(dl
         :row-gap "8px"
         :column-gap "14px")
       `(dt
         :background-color ,theme:background-color+
         :color ,theme:on-background-color
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-weight "400"
         :font-size "0.9em"
         :border-radius "6px"
         :padding "3px 9px"
         :height "fit-content")
       `("::selection"
         :background-color ,theme:primary-color
         :color ,theme:on-primary-color)
       '("::-webkit-scrollbar"
         :width "8px")
       '("::-webkit-scrollbar-track"
         :background "transparent")
       `("::-webkit-scrollbar-thumb"
         :background-color ,(%hairline theme:on-background-color 0.18)
         :border-radius "8px"))))))

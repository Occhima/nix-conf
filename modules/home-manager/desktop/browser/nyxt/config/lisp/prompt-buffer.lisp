(in-package #:nyxt-user)

(define-configuration prompt-buffer
  ((style
    (str:concat
     %slot-value%
     (theme:themed-css (theme *browser*)
       `("html, body"
         :height "100%"
         :margin "0"
         :padding "0"
         :background ,theme:background-color
         :box-sizing "border-box")
       `(body
         :color ,theme:on-background-color
         :font-family ,(%mono-stack theme:monospace-font-family)
         :font-size "13px"
         :letter-spacing "0.01em")
       `("#root"
         :height "100%"
         :box-sizing "border-box"
         :display "grid"
         :grid-template-rows "auto 1fr"
         :row-gap "6px"
         :padding "10px 0 6px 0"
         :background-color ,theme:background-color
         :border-top ,(format nil "1px solid ~a"
                              (%hairline theme:on-background-color 0.18)))
       `("#prompt-area"
         :margin "0 0 4px 0"
         :height "34px"
         :align-items "center"
         :border "none"
         :border-radius "0"
         :background-color "transparent"
         :box-shadow ,(format nil "inset 0 -1px 0 0 ~a"
                              (%hairline theme:on-background-color 0.10)))
       `("#prompt"
         :background-color "transparent"
         :color ,theme:primary-color
         :font-size "10px"
         :letter-spacing "0.10em"
         :text-transform "uppercase"
         :line-height "34px"
         :padding "0 2px 0 14px"
         :max-width "24ch")
       '("#prompt-input"
         :line-height "34px"
         :padding "0 6px"
         :min-width "12ch")
       `("#prompt-extra"
         :background-color "transparent"
         :color ,theme:primary-color
         :font-size "10px"
         :line-height "34px"
         :padding-right "14px")
       '("#prompt-modes, #close-button"
         :display "none")
       '("#previous-source, #next-source, #toggle-attributes"
         :display "none")
       `(input
         :font-family ,(%mono-stack theme:monospace-font-family))
       `("#input"
         :height "34px"
         :border "none"
         :border-radius "0"
         :padding "0"
         :background-color "transparent"
         :color ,theme:on-background-color
         :font-size "14px"
         :box-shadow "none"
         :outline "none"
         :caret-color ,theme:action-color)
       '("#input:focus"
         :box-shadow "none")
       '("#suggestions"
         :margin "0"
         :min-height "0"
         :overflow-y "auto"
         :overflow-x "hidden")
       '(".source"
         :margin "0 0 14px 0")
       '(".source:last-of-type"
         :margin-bottom "0")
       `(".source-name"
         :background-color "transparent"
         :color ,theme:primary-color
         :font-size "10px"
         :letter-spacing "0.10em"
         :text-transform "uppercase"
         :border-radius "0"
         :border "none"
         :padding "0 0 6px 14px")
       '(".source-name > div"
         :line-height "14px")
       '(".source-content th"
         :display "none")
       `(".source-content"
         :padding-left "0"
         :margin-left "0"
         :border-spacing "0 2px"
         :table-layout "auto"
         (td
          :height "24px"
          :padding "0 14px 0 0"
          :border-radius "0"
          :color ,theme:primary-color
          :overflow "hidden"
          :text-overflow "ellipsis"
          :white-space "nowrap")
         ("td:first-child"
          :color ,theme:on-background-color
          :width "1%"
          :padding-left "14px"
          :white-space "nowrap")
         ("tr:hover td"
          :background-color ,(%hairline theme:on-background-color 0.07)))
       '(".source-content col"
         :width "auto !important")
       `("#selection"
         :background-color ,theme:secondary-color)
       `("#selection td"
         :background-color ,theme:secondary-color
         :color ,theme:on-background-color)
       `(.marked
         :background-color "transparent"
         :color ,theme:on-background-color)
       `(.selected
         :background-color "transparent"
         :color ,theme:on-background-color)
       '("::-webkit-scrollbar"
         :width "6px")
       '("::-webkit-scrollbar-track"
         :background "transparent")
       `("::-webkit-scrollbar-thumb"
         :background-color ,(%hairline theme:on-background-color 0.18)
         :border-radius "6px"))))))

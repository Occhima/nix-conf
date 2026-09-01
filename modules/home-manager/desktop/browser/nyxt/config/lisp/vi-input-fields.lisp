(in-package #:nyxt-user)

(defun %no-vi-insert-on-input-fields (buffer)
  "Leave BUFFER's vi mode alone when a page focuses an editable element.

The shipped version asks the page whether its active element is editable and
switches mode on the answer, which is a synchronous round trip, plus a status
redraw on a switch that is another -- all of it inside the key press, button
press and focus callbacks that call it.  The renderer waits on those
callbacks, so the palette wedges mid-keystroke.  Press `i' instead, which is
what a vi user's fingers do anyway.

`nyxt/mode/vi' is a locked package, so replacing the definition needs the
lock lifted; the shipped one is left as the value of a variable rather than
dropped, so putting it back is one form in the REPL."
  (declare (ignore buffer))
  nil)

(defvar *vi-insert-on-input-fields*
  (fdefinition 'nyxt/mode/vi::vi-insert-on-input-fields)
  "The shipped `vi-insert-on-input-fields', before the no-op replaced it.")

(sb-ext:with-unlocked-packages (:nyxt/mode/vi)
  (setf (fdefinition 'nyxt/mode/vi::vi-insert-on-input-fields)
        #'%no-vi-insert-on-input-fields))

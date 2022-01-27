(import freja/new_gap_buffer :as gb)
(import freja/state)
(import freja/default-hotkeys :as dh)

# XXX: for investigation
(defn current-gb
  []
  (get-in state/editor-state [:stack 0 1 :editor :gb]))

(varfn point
  [gb]
  (gb :caret))

(varfn char-after
  [gb i]
  (gb/gb-nth gb i))

(varfn goto-char
  [gb i]
  (gb/put-caret gb i))

 " hello there"

# XXX: review
(varfn skip-whitespace-forward-on-line
  ``
  Skips forward while there is whitespace but stop
  if end of line is reached.
  ``
  [gb]
  (def {:caret caret} gb)

  (var target-i caret)
  (def start-i caret)

  (def f
    (fiber/new
      (fn []
        (gb/index-char-start gb start-i))))

  (when (= (chr "\n") (char-after gb caret))
    (break nil))

  (loop [[i c] :iterate (resume f)]
    (when (and (not= (chr " ") c)
               (not= (chr "\t") c))
      (set target-i i)
      (break)))

  (if (> target-i (gb/gb-length gb))
    nil
    (gb/move-n gb (- target-i start-i))))

(varfn skip-whitespace-backward-on-line
  ``
  Skips backward while there is whitespace but stop
  before previous end of line if any.
  ``
  [gb]
  (def {:caret caret} gb)

  (when (zero? caret)
    (break))

  (when (= (chr "\n") (char-after gb (dec caret)))
    (break nil))

  (var target-i (dec caret))
  (def start-i (dec caret))

  (def f
    (fiber/new
      (fn []
        (gb/index-char-backward-start gb start-i))))

  (loop [[i c] :iterate (resume f)]
    (when (and (not= (chr "\n") c)
               (not= (chr " ") c)
               (not= (chr "\t") c))
      (set target-i i)
      (break)))

  (def diff
    (- target-i start-i))

  # XXX: does this cover all cases?
  (unless (= start-i target-i)
    (gb/move-n gb diff)))

(varfn single-space
  [gb]
  (def current (point gb))
  # find bounds for potential deletion
  (def [start end]
    (do
      (skip-whitespace-backward-on-line gb)
      (def start
        (let [here (point gb)
              left (dec here)
              char-left (char-after gb left)]
          (if (or (= (chr " ") char-left)
                  (= (chr "\t") char-left))
            left
            here)))
      (goto-char gb current)
      (skip-whitespace-forward-on-line gb)
      (def end (point gb))
      [start end]))
  (goto-char gb start)
  (gb/delete-region! gb start end)
  (goto-char gb start)
  (gb/insert-string-at-pos! gb start " ")
  (gb/move-n gb 1))

(dh/set-key dh/gb-binds
            [:alt :space]
            (comp dh/reset-blink single-space))


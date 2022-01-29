(import freja/default-hotkeys :as dh)

(import ./freja-single-space :as fss)

(dh/set-key dh/gb-binds
            [:alt :space]
            (comp dh/reset-blink fss/single-space))


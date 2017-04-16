(deftheme default-black
  "Magnar's theme")

(custom-theme-set-faces
 'default-black
 '(default ((t (:inherit nil :stipple nil :background "#2d2d2d" :foreground "White"))))
 '(highlight ((((class color) (min-colors 88) (background dark)) (:background "#8abeb7"))))
 '(region ((nil (:background "#f2777a"))))
 '(hl-line ((nil (:background "#81a2be")))))

(provide-theme 'default-black)

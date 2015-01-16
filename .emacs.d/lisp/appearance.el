;;; appearance.el --- Appearance settings.

;;; Commentary:

;;; Code:

(defun jdahm/color-theme-init ()
  "Initializes the jdahm/color-theme-* variables."
  (defvar jdahm/color-theme-dark 'wombat "Dark color theme.")
  (defvar jdahm/color-theme-light 'leuven "Light color theme.")
  (defvar jdahm/color-theme-type jdahm/color-theme-dark "Default color theme."))

(defun jdahm/toggle-color-theme-var ()
  "Cycles jdahm/color-theme-type variable."
  (if (equal jdahm/color-theme-type jdahm/color-theme-dark)
      (setq jdahm/color-theme-type jdahm/color-theme-light)
    (setq jdahm/color-theme-type jdahm/color-theme-dark)))

(defun jdahm/toggle-color-theme ()
  "Sets dark color theme and toggles variable."
  (interactive)
  (disable-theme jdahm/color-theme-type)
  (jdahm/toggle-color-theme-var)
  (load-theme jdahm/color-theme-type t))


(jdahm/color-theme-init)
(load-theme jdahm/color-theme-type t)

(provide 'appearance)

;; appearance.el ends here

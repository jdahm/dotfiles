;;; appearance.el --- Appearance settings.

;;; Commentary:

;;; Code:

(defun jdahm/toggle-color-theme-var ()
  "Cycles jdahm/color-theme-type variable."
  (if (equal jdahm/color-theme jdahm/color-theme-dark)
      (setq jdahm/color-theme jdahm/color-theme-light)
    (setq jdahm/color-theme jdahm/color-theme-dark)))

(defun jdahm/toggle-color-theme ()
  "Set dark color theme and toggle variable."
  (interactive)
  (disable-theme jdahm/color-theme)
  (jdahm/toggle-color-theme-var)
  (load-theme jdahm/color-theme t))

(provide 'appearance)

;;; appearance.el ends here

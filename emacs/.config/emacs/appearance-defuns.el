(defun clear-current-theme ()
  "Disable current-theme."
  (interactive)
  (disable-theme current-theme))

(defun cycle-my-themes ()
  "Cycle through a list of themes, MY-THEMES"
  (interactive)
  (when current-theme
    (clear-current-theme)
    (setq my-themes (append my-themes (list current-theme))))
  (setq current-theme (pop my-themes))
  (load-theme current-theme t))

(provide 'appearance-defuns)

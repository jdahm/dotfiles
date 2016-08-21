(defun kill-current-buffer (arg)
  "Kill the current buffer."
  (interactive "P")
  (if arg
      (kill-buffer)
    (kill-buffer (current-buffer))))

(defun create-scratch-buffer ()
  "Create a new scratch buffer to work in. (could be *scratch* - *scratchX*)"
  (interactive)
  (let ((n 0)
        bufname)
    (while (progn
             (setq bufname (concat "*scratch"
                                   (if (= n 0) "" (int-to-string n))
                                   "*"))
             (setq n (1+ n))
             (get-buffer bufname)))
    (switch-to-buffer (get-buffer-create bufname))
    (emacs-lisp-mode)
    ))

(defun prev-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (other-buffer)))

(provide 'jd-buffer)

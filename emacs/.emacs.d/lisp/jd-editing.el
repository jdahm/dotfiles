;;; jd-editing.el --- Functions for editing.

;; Source: magnars/.emacs.d

(defun my-change-number-at-point (change)
  (let ((number (number-at-point))
        (point (point)))
    (when number
      (progn
        (forward-word)
        (search-backward (number-to-string number))
        (replace-match (number-to-string (funcall change number)))
        (goto-char point)))))

(defun increment-number-at-point ()
  "Increment number at point like vim's C-a"
  (interactive)
  (my-change-number-at-point '1+))

(defun decrement-number-at-point ()
  "Decrement number at point like vim's C-x"
  (interactive)
  (my-change-number-at-point '1-))

(defun move-line-up ()
  "Transposes the line at point with the line above."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  "Transposes the line at point with the line below it."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun date ()
  "Inserts the current date in the format %Y-%m-%d."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(defun time ()
  "Inserts the current time in the format %H:%M:%S."
  (interactive)
  (insert (format-time-string "%H:%M:%S")))

(defun tidy-region-or-buffer ()
  "Indent, delete whitespace, and untabify the region or buffer."
  (interactive)
  (save-excursion
    (let ((begin (point-min)) (end (point-max)))
      (when (region-active-p)
        (setq begin (region-beginning))
        (setq end (region-end)))
    (delete-trailing-whitespace begin end)
    (indent-region begin end nil))))

(provide 'jd-editing)

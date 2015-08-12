;;; editing-defuns.el --- Functions for editing

;;; Commentary:

;; Source: https://github.com/magnars/.emacs.d/

;;; Code:

(defun tidy-region-or-buffer ()
  "Indent, delete whitespace, and untabify the region or buffer."
  (interactive)
  (save-excursion
    (let ((begin (point-min)) (end (point-max)))
      (when (region-active-p)
        (setq begin (region-beginning))
        (setq end (region-end)))
    (delete-trailing-whitespace begin end)
    (indent-region begin end nil)
    (untabify begin end))))

(defun date ()
  "Inserts the current date in the format %Y-%m-%d."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))

(defun time ()
  "Inserts the current time in the format %H:%M:%S."
  (interactive)
  (insert (format-time-string "%H:%M:%S")))

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

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(defun my-beginning-of-line ()
  "Toggle between `beginning-of-line' and `back-to-indentation'."
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(defun cycle-tab-width ()
  "Cycle 'tab-width' between values 2, 4, and 8."
  (interactive)
  (setq tab-width
        (cond ((eq tab-width 8) 2)
              ((eq tab-width 2) 4)
              (t 8)))
  (message "%s %d" "tab-width =" tab-width)
  (redraw-display))

(defun my-url-insert-file-contents (url)
  "Prompt for URL and insert file contents at point."
  (interactive "sURL: ")
  (url-insert-file-contents url))

(defun dcaps-to-scaps ()
  "Convert word in DOuble CApitals to Single Capitals."
  (interactive)
  (and (= ?w (char-syntax (char-before)))
       (save-excursion
         (and (if (called-interactively-p)
                  (skip-syntax-backward "w")
                (= -3 (skip-syntax-backward "w")))
              (let (case-fold-search)
                (looking-at "\\b[[:upper:]]\\{2\\}[[:lower:]]"))
              (capitalize-word 1)))))

(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")

(defun edit-emacs-init ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(provide 'editing-defuns)

;;; editing-defuns.el ends here

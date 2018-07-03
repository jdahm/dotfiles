(defun require-package (package)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

(defun create-scratch-buffer nil
  "create a scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(defun tidy-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
    (if (region-active-p)
        (progn
	  (delete-trailing-whitespace (region-beginning) (region-end))
          (indent-region (region-beginning) (region-end) nil)
	  (untabify (point-min) (point-max)))
      (progn
	(delete-trailing-whitespace)
	(indent-region (point-min) (point-max) nil)
	(untabify (point-min) (point-max)))))

;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph
(defun unfill-paragraph (&optional region)
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
	;; This would override `fill-column' if it's an integer.
	(emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical splits."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

;; Source: https://stackoverflow.com/questions/2416655/file-path-to-clipboard-in-emacs
(defun prelude-copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

;; vim-style increment/decrement numbers
;; Source: https://gist.github.com/d11wtq/5836174
(defun inc-number-at-point (n)
  "Increment the number under the point, if present.
Called with a prefix argument, changes the number by N."
  (interactive "p")
  (let ((amt (or n 1))
        (word (thing-at-point 'word))
        (bounds (bounds-of-thing-at-point 'word)))
    (when (string-match "^[0-9]+$" word)
      (replace-string word
                      (format "%d" (+ amt (string-to-int word)))
                      nil (car bounds) (cdr bounds))
      (forward-char -1))))

(defun dec-number-at-point (n)
  "Increment number at point like vim's C-a"
  (interactive "p")
  (inc-number-at-point (- n)))

(defun dired-open-fm ()
  "Open a GUI file manager at (dired-current-directory) using
xdg-open."
  (interactive)
  (if (string-equal system-type "darwin")
      (call-process "open" nil 0 nil (dired-current-directory))
    (call-process "xdg-open" nil 0 nil (dired-current-directory))))

(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (if (string-equal system-type "darwin")
	(call-process "open" nil 0 nil file)
      (call-process "xdg-open" nil 0 nil file))
    (message "Opening %s done" file)))

(provide 'jd-extra)

;;; defuns.el --- Some extra utility functions

;;; Commentary:

;;; Code:

(defun tidy-region (start end)
  "Indent, delete whitespace, and untabify the region."
  (interactive "r")
  (progn
    (delete-trailing-whitespace start end)
    (indent-region start end nil)
    (untabify start end)))

(defun tidy-buffer ()
  "Indent, delete whitespace, and untabify the buffer."
  (interactive)
  (save-excursion
    (tidy-region (point-min) (point-max))))

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

(defun kill-current-buffer ()
  "Kills the current buffer. Meant to "
  (interactive)
  (kill-buffer (current-buffer)))

(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun beautify-json ()
  "Calls `jsonpp' on the region between mark and point."
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "jsonpp" (buffer-name) t)))

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(setq search-engine-url "http://www.google.com/search?ie=utf-8&oe=utf-8&q=")

(defun search-engine ()
  "Search the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat search-engine-url
    (url-hexify-string (if mark-active
                           (buffer-substring (region-beginning) (region-end))
                         (read-string "Search: "))))))

(defun recentf-ido-find-file ()
  "Find a recent file using Ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

(defun jdahm/show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name)))

(defun jdahm/switch-to-minibuffer-window ()
  "Switch to minibuffer window (if active)."
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

(defun jdahm/beginning-of-line ()
  "Toggle between `beginning-of-line' and `back-to-indentation'."
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(defun jdahm/split-window()
  "Split the window to see the most recent buffer in the other window.
Call a second time to restore the original window configuration."
  (interactive)
  (if (eq last-command 'my-split-window)
      (progn
        (jump-to-register :my-split-window)
        (setq this-command 'my-unsplit-window))
    (window-configuration-to-register :my-split-window)
    (switch-to-buffer-other-window nil)))

(defun jdahm/toggle-window-split ()
  "Change window split from vertical to horizontal and vice versa."
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

(defun jdahm/prev-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun jdahm/url-insert-file-contents (url)
  "Prompt for URL and insert file contents at point."
  (interactive "sURL: ")
  (url-insert-file-contents url))

(defun jdahm/cycle-tab-width ()
  "Cycle 'tab-width' between values 2, 4, and 8."
  (interactive)
  (setq tab-width
        (cond ((eq tab-width 8) 2)
              ((eq tab-width 2) 4)
              (t 8)))
  (message "%s %d" "tab-width =" tab-width)
  (redraw-display))


(provide 'utils)

;; utils.el ends here

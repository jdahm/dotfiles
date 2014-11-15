;;; defuns.el --- Some extra functions

;;; Commentary:

;;; A few functions defined to make certain operations easier.

;;; Code:

(defun my-show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name)))

(defun my-url-insert-file-contents (url)
  "Prompt for URL and insert file contents at point."
  (interactive "sURL: ")
  (url-insert-file-contents url))

(defun my-indent-whole-buffer ()
  "Indent entire buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun my-switch-to-minibuffer-window ()
  "Switch to minibuffer window (if active)."
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))

(defun my-beginning-of-line ()
  "Toggle between `beginning-of-line' and `back-to-indentation'."
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(defun my-split-window()
  "Split the window to see the most recent buffer in the other window.
Call a second time to restore the original window configuration."
  (interactive)
  (if (eq last-command 'my-split-window)
      (progn
        (jump-to-register :my-split-window)
        (setq this-command 'my-unsplit-window))
    (window-configuration-to-register :my-split-window)
    (switch-to-buffer-other-window nil)))

(defun my-toggle-window-split ()
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

(defun my-toggle-show-trailing-whitespace ()
  "Toggle `show-trailing-whitespace' between t and nil."
  (interactive)
  (setq show-trailing-whitespace (not show-trailing-whitespace))
  (setq-default indicate-empty-lines (not indicate-empty-lines))
  (redraw-display))

(defun my-prev-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun my-tab-width ()
  "Cycle 'tab-width' between values 2, 4, and 8."
  (interactive)
  (setq tab-width
        (cond ((eq tab-width 8) 2)
              ((eq tab-width 2) 4)
              (t 8)))
  (message "%s %d" "tab-width =" tab-width)
  (redraw-display))

(defun sudo-save-buffer ()
  "Save a buffer to file using sudo via TRAMP."
  (interactive)
  (if (not buffer-file-name)
      (write-file (concat "/sudo:root@localhost:" (read-string "File: ")))
    (write-file (concat "/sudo:root@localhost:" buffer-file-name))))


(provide 'defuns)

;;; defuns.el ends here

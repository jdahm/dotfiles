;; Sources:
;;   * sjrmanning/.emacs.d
;;   * magnars/.emacs.d
;;   * muahah/emacs-profile

(defun require-package (package)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

(defun emacsd-path (path)
  "Return path inside user's `.emacs.d'."
  (expand-file-name path user-emacs-directory))

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

(defun kill-current-buffer (arg)
  "Kill the current buffer."
  (interactive "P")
  (if arg
      (kill-buffer)
    (kill-buffer (current-buffer))))

(defun prev-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (other-buffer)))

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

(defun save-kbd-macro (name)
  "save a macro. Take a name as argument
     and save the last defined macro under
     this name at the end of your .emacs"
  (interactive "Name of the macro :")   ; ask for the name of the macro
  (kmacro-name-last-macro name)         ; use this name for the macro
  (find-file custom-file)               ; open up custom.el file
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer

(defun create-and-refresh-tags (&optional files-cmd)
  "Create tags file."
  (interactive)
  (if files-cmd
      (let ((tags-revert-without-query t))
        (call-process-shell-command (format "%s | etags -" files-cmd))
        (visit-tags-table default-directory nil))
    (let ((default-directory
            (replace-regexp-in-string "\n$" ""
                                      (shell-command-to-string "git rev-parse --show-toplevel")))
          (tags-revert-without-query t))
      (call-process-shell-command "git ls-files > thefiles")
      (call-process-shell-command "git ls-files | etags -")
      (visit-tags-table default-directory nil))))

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

(provide 'jd-defuns)

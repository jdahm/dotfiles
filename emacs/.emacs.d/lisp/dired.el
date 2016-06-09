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

(defun project-root ()
  "Return the project root for current buffer."
  (let ((directory default-directory))
    (or (locate-dominating-file directory ".git")
        (locate-dominating-file directory ".svn")
        (locate-dominating-file directory ".hg"))))

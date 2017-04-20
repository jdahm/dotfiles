;; Sources:
;; - abo-abo/oremacs

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

(defun sudired ()
  (interactive)
  (require 'tramp)
  (let ((dir (expand-file-name default-directory)))
    (if (string-match "^/sudo:" dir)
        (user-error "Already in sudo")
      (dired (concat "/sudo::" dir)))))


;; -*- lexical-binding: t -*-
(defun ora-ediff-files ()
  (interactive)
  (let ((files (dired-get-marked-files))
        (wnd (current-window-configuration)))
    (if (<= (length files) 2)
        (let ((file1 (car files))
              (file2 (if (cdr files)
                         (cadr files)
                       (read-file-name
                        "file: "
                        (dired-dwim-target-directory)))))
          (if (file-newer-than-file-p file1 file2)
              (ediff-files file2 file1)
            (ediff-files file1 file2))
          (add-hook 'ediff-after-quit-hook-internal
                    (lambda ()
                      (setq ediff-after-quit-hook-internal nil)
                      (set-window-configuration wnd))))
      (error "no more than 2 files should be marked"))))

(provide 'jd-dired)

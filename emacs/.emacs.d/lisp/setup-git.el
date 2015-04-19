(global-set-key (kbd "C-x g") 'magit-status)
(add-hook 'magit-mode-hook 'magit-load-config-extensions)
(setq magit-last-seen-setup-instructions "1.4.0"
      magit-completing-read-function 'ivy-completing-read
      magit-status-buffer-switch-function 'switch-to-buffer)

(defun git-grep-prompt ()
  "Helper function for `git-grep'"
  (let* ((default (current-word))
         (prompt (if default
                     (concat "Search for: (default " default ") ")
                   "Search for: "))
         (search (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length search) 0)
        search
      (or default ""))))

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive (list (git-grep-prompt)))
  (grep-find (concat "git --no-pager grep -P -n "
                     (shell-quote-argument search)
                     " `git rev-parse --show-toplevel`")))

(defun couns-git ()
  "Find file in the current Git repository."
  (interactive)
  (let* ((default-directory (locate-dominating-file
                             default-directory ".git"))
         (cands (split-string
                 (shell-command-to-string
                  "git ls-files --full-name --")
                 "\n"))
         (file (ivy-read "Find file: " cands)))
    (when file
      (find-file file))))

(defun compile-dir ()
  (let* ((default (locate-dominating-file
                            default-directory ".git"))
         (prompt (if default
                     (concat "Directory: (default " default ") ")
                   "Directory: "))
         (directory (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length directory) 0)
        directory
      (or default ""))))

(defun compile-tar ()
  (let* ((default "all")
         (prompt (concat "Taget: (default all) "))
         (target (read-from-minibuffer prompt nil nil nil nil default)))
    (if (> (length target) 0)
        target
      (or default ""))))

(defun git-compile ()
  "Run `compile' at a directory with a target."
  (interactive)
  (let ((directory (compile-dir))
        (target (compile-tar)))
    (compile (concat "make -k -C " directory " " target))))

(provide 'setup-git)

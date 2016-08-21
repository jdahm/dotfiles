;; Source: http://snarfed.org/emacs-vc-git-tweaks
;; In vc-git and vc-dir for git buffers, make (C-x v) a run git add, u run git
;; reset, and r run git reset and checkout from head.
(defun my-vc-git-command (verb fn)
  (let* ((fileset-arg (or vc-fileset (vc-deduce-fileset nil t)))
         (backend (car fileset-arg))
         (files (nth 1 fileset-arg)))
    (if (eq backend 'Git)
        (progn (funcall fn files)
               (message (concat verb " " (number-to-string (length files))
                                " file(s).")))
      (message "Not in a vc git buffer."))))

(defun my-vc-git-add (&optional revision vc-fileset comment)
  (interactive "P")
  (my-vc-git-command "Staged" 'vc-git-register))

(defun my-vc-git-reset (&optional revision vc-fileset comment)
  (interactive "P")
  (my-vc-git-command "Unstaged"
		     (lambda (files) (vc-git-command nil 0 files "reset" "-q" "--"))))

(defun my-vc-refresh ()
  (interactive)
  (vc-dir-refresh) (vc-dir-hide-up-to-date))

;; (define-key vc-prefix-map [(r)] 'vc-revert-buffer)
;; (define-key vc-dir-mode-map [(r)] 'vc-revert-buffer)
;; (define-key vc-prefix-map [(a)] 'my-vc-git-add)
;; (define-key vc-dir-mode-map [(a)] 'my-vc-git-add)
;; (define-key vc-prefix-map [(u)] 'my-vc-git-reset)
;; (define-key vc-dir-mode-map [(u)] 'my-vc-git-reset)

;; hide up to date files after refreshing in vc-dir
;; (define-key vc-dir-mode-map [(g)]
;;   (lambda () (interactive) (vc-dir-refresh) (vc-dir-hide-up-to-date)))

(provide 'jd-git)

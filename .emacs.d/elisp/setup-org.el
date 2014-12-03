;;; setup-org.el --- My setup for org-mode

;;; Commentary:

;;; My settings.

;;; Code:

(require 'org)

(setq
 org-directory "~/Dropbox/org/"  ; default directory for notes
 org-default-notes-file (concat org-directory "notes.org") ; default target file for notes
 org-agenda-start-on-weekday 6 ; start weeks on Saturdays
 )

(setq org-agenda-files (list (concat org-directory "personal.org")
                             (concat org-directory "work.org")))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n %a")
        ("p" "Personal task" entry (file+headline (concat org-directory "personal.org") "Tasks")
         "* TODO %?")
        ("w" "Work task" entry (file+headline (concat org-directory "work.org") "Tasks")
         "* TODO %?\n %a")))

(setq org-todo-keywords
 '((sequence
    "TODO(t)"
    "STARTED(s)"
    "WAITING(w@/!)"
    "SOMEDAY(.)" "|" "DONE(x!)" "CANCELLED(c@)")
   (sequence "TODELEGATE(-)" "DELEGATED(d)" "COMPLETE(x)")
   (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")))

(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c l")   'org-store-link)
(global-set-key (kbd "C-c a")   'org-agenda)

;; Org-present

(add-hook 'org-present-mode-hook
          (lambda ()
            (org-present-big)
            (org-display-inline-images)))

(add-hook 'org-present-mode-quit-hook
          (lambda ()
            (org-present-small)
            (org-remove-inline-images)))

(provide 'org-setup)

;;; setup-org.el ends here

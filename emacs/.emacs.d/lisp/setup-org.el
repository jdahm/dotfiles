(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq
 org-directory "~/Sync/org/"                                               ; directory for notes
 org-default-notes-file (concat org-directory "notes.org")                    ; default file
 org-agenda-files (list (concat org-directory "personal.org")
                        (concat org-directory "work.org"))                    ; agenda files
 org-archive-location "~/Sync/org/datetree.org::datetree/* Finished Tasks" ; archive format
 )

(setq
 org-modules '(org-habit)                               ; modules for org-mode
 org-agenda-start-on-weekday 6                          ; start weeks on Saturdays
 org-clock-idle-time 15                                 ; idle time
 org-refile-targets '((nil :maxlevel . 1)
                      (org-agenda-files :maxlevel . 1)) ; flexible refiling
 )

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline org-default-notes-file "Tasks")
         "* TODO %?\n %a")
        ("p" "Personal task" entry (file+headline (concat org-directory "personal.org") "Tasks")
         "* TODO %?")
        ("w" "Work task" entry (file+headline (concat org-directory "work.org") "Tasks")
         "* TODO %?\n %a")
        ("l" "Ledger entries")
        ("lv" "VISA" plain
         (file "~/Documents/Finances/finances.ledger")
         "%(org-read-date) %^{Payee}
  Liabilities:VISA
  Expenses:%^{Account}  %^{Amount}
")
        ("lc" "Cash" plain
         (file "~/Documents/Finances/finances.ledger")
         "%(org-read-date) * %^{Payee}
  Expenses:Cash
  Expenses:%^{Account}  %^{Amount}
")))

(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "STARTED(s)"
         "WAITING(w@/!)"
         "SOMEDAY(.)" "|" "DONE(x!)" "CANCELLED(c@)")
        (sequence "TODELEGATE(-)" "DELEGATED(d)" "COMPLETE(x)")
        (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")))

(setq org-latex-pdf-process (list "latexmk -lualatex -f %f"))

(setq org-completion-use-ido t)

(provide 'setup-org)

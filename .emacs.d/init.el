;;; init.el

;;; Early settings

;; Personal info
(setq
 user-full-name "Johann Dahm"               ; name
 user-mail-address "johann.dahm@gmail.com"  ; email
 )

;; Turn off scrollbar, toolbar, etc. early in startup to avoid window width weirdness
(when (display-graphic-p)
  (scroll-bar-mode -1)  ; disable the scroll bar
  (tool-bar-mode -1)    ; disable the awful toolbar
  (tooltip-mode -1)     ; disable tool tips
  )

;; Local customization file
(setq custom-file "~/.config/emacs/init-custom.el")
(if (file-readable-p custom-file) (load custom-file))


;;; Keys

(global-set-key (kbd "C-a") 'my-beginning-of-line)

(global-set-key (kbd "C-c q")   'auto-fill-mode)
(global-set-key (kbd "C-c s")   'shell)
(global-set-key (kbd "C-c \\")  'align-regexp)
(global-set-key (kbd "C-c f")   'flycheck-mode)
(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c l")   'org-store-link)
(global-set-key (kbd "C-c a")   'org-agenda)
(global-set-key (kbd "C-c g")   'magit-status)
(global-set-key (kbd "C-c l")   'magit-log)
(global-set-key (kbd "C-c m")   'my-last-buffer)
(global-set-key (kbd "C-c w")   'my-toggle-show-trailing-whitespace)
(global-set-key (kbd "C-c C-w") 'whitespace-mode)
(global-set-key (kbd "C-c t")   'my-tab-width)

(global-set-key (kbd "C-h TAB") 'my-indent-whole-buffer)
(global-set-key (kbd "C-h C-m") 'discover-my-major)
(global-set-key (kbd "C-h C-z") 'projectile-find-file)
(global-set-key (kbd "C-h z")   'projectile-ag)

(global-set-key (kbd "C-x C-u") 'my-url-insert-file-contents)
(global-set-key (kbd "C-x k")   'my-kill-buffer)
(global-set-key (kbd "C-x C-q") 'toggle-read-only)
(global-set-key (kbd "C-x g")   'magit-status)

(global-set-key (kbd "M-<up>")   (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "M-<down>") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "M-9")    'my-switch-to-minibuffer-window)

(global-set-key (kbd "<f6>") 'my-prev-buffer)
(global-set-key (kbd "<f7>") 'my-split-window)
(global-set-key (kbd "<f8>") 'my-toggle-window-split)

(define-key emacs-lisp-mode-map (kbd "M-.") 'find-function-at-point)


;;; Functions

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
  "Toggle show-trailing-whitespace between t and nil."
  (interactive)
  (setq show-trailing-whitespace (not show-trailing-whitespace))
  (setq-default indicate-empty-lines (not indicate-empty-lines))
  (redraw-display))

(defun my-kill-buffer ()
  "Kills current buffer without asking for buffer name."
  (interactive)
  (kill-buffer (buffer-name)))

(defun my-prev-buffer ()
  "Switch to previous buffer."
  (interactive)
  (switch-to-buffer (other-buffer)))

(defun my-tab-width ()
  "Cycle tab-width between values 2, 4, and 8."
  (interactive)
  (setq tab-width
        (cond ((eq tab-width 8) 2)
              ((eq tab-width 2) 4)
              (t 8)))
  (message "%s %d" "tab-width =" tab-width)
  (redraw-display))

(defun my-beginning-of-line ()
  "Toggles between (beginning-of-line) and (back-to-indentation)."
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

(defun sudo-save-buffer ()
  "Saves a buffer to file using sudo via TRAMP."
  (interactive)
  (if (not buffer-file-name)
      (write-file (concat "/sudo:root@localhost:" (read-string "File: ")))
    (write-file (concat "/sudo:root@localhost:" buffer-file-name))))


;;; General settings

;; Save backup files to dedicated folder
(setq backup-directory-alist '(("." . "~/.emacs.d/saves/")))

;; Persistence directory
(setq emacs-persistence-directory (concat user-emacs-directory "persistence/"))
(unless (file-exists-p emacs-persistence-directory)
  (make-directory emacs-persistence-directory t))

;; Switch 'yes' or 'no' questions to 'y' or 'n'
(fset 'yes-or-no-p 'y-or-n-p)

(setq
 sentence-end-double-space nil          ; sentences end with single space
 confirm-nonexistent-file-or-buffer nil ; don't confirm the creation of files
 inhibit-startup-screen t               ; don't show the startup screen
 initial-scratch-message nil            ; don't show message in the scratch buffer
 )


;;; Navigation

;; Better buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Better window navigation
(require 'windmove)
(windmove-default-keybindings)

;; Remember cursor position in each file
(require 'saveplace)
(setq save-place-file (concat emacs-persistence-directory
                              "saved-places"))
(setq-default save-place t)

;; Remember minibuffer history
(require 'savehist)
(setq savehist-file (concat emacs-persistence-directory
                            "saved-history"))
(savehist-mode 1)


;;; Org-mode

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


;;; Programming

;; Show matching parens
(show-paren-mode t)

;; Useful to see the column number
(setq column-number-mode t)

;; Use spaces; not tabs!
(setq-default
 tab-width 2
 indent-tabs-mode nil  ; use spaces instead of tabs
 c-basic-offset 2      ; "tab" with in c-related modes
 fill-column 80        ; Default fill column
 )


;;; C

;; Indent switch cases
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-offset 'case-label '+)))


;;; Octave

;; Treat .m files as octave (not objective-C)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; Turn on the abbrevs, auto-fill and font-lock features
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))


;;; OS X

(when (eq system-type 'darwin)
  ;; OS X 'ls' doesn't support '--dired' flag.
  (setq dired-use-ls-dired nil)
  ;; Use Spotlight for M-x locate
  (setq locate-command "mdfind")
  ;; Sane trackpad scrolling
  (setq mouse-wheel-scroll-amount '(1 ((control)))))


;;; Colors/Theme
(when (>= emacs-major-version 24)
  (load-theme 'wombat t))


;;; Package manager

(defvar my-packages
  '(markdown-mode
    clojure-mode
    d-mode
    haskell-mode
    projectile
    magit
    discover-my-major
    guru-mode
    ))

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p)))

  ;;; Guru-mode
  ;; Use in programming modes
  (add-hook 'prog-mode-hook 'guru-mode)

  ;;; Markdown
  ;; Treat .md files as markdown
  (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
  (setq-default markdown-indent-on-enter nil)

  ;;; Projectile
  (projectile-global-mode)
  (setq projectile-mode-line '(:eval (format " Proj[%s]" (projectile-project-name))))

  ;;; Magit
  ;; Open in full window
  (setq magit-status-buffer-switch-function 'switch-to-buffer))

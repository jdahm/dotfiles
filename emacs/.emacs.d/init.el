;;; init.el --- jdahm's GNU Emacs config

;;; Commentary:

;;; sources:
;; * abo-abo/oremacs
;; * wasamasa/dotemacs

;;; Code:

(defvar emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "The giant turtle on which the world rests.")

(defvar config-d (expand-file-name "emacs/" "~/.config/"))
(defvar lisp-d (expand-file-name "lisp/" emacs-d))

(defvar local-init-file (expand-file-name "init.el" config-d))

;; Load customizations through custom-set-variable
(setq custom-file (expand-file-name "custom.el" config-d))
(if (file-readable-p custom-file) (load-file custom-file))

;; Source: http://stackoverflow.com/questions/12058717/confusing-about-the-emacs-custom-system
(defmacro csetq (var val)
  "Call `customize-set-variable' to set VAR to VAL."
  `(funcall 'customize-set-variable ',var ,val))

;; Initialize the package interface
(setq package-user-dir (expand-file-name "elpa" emacs-d))
(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("melpa"        . "https://melpa.org/packages/")))
(package-initialize)

;; Install use-package -- handles the rest of the package config
(when (not package-archive-contents) (package-refresh-contents))
(let ((p 'use-package))
  (when (not (package-installed-p p))
    (package-install p)))

(use-package markdown-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.text$"     . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md$"       . markdown-mode)))

(use-package yaml-mode :ensure t)
(use-package haskell-mode :ensure t)
(use-package clojure-mode :ensure t)
(use-package gnuplot-mode :ensure t)
(use-package ledger-mode :ensure t)

;; Theme
(add-to-list 'custom-theme-load-path (expand-file-name "themes/" emacs-d))
;; (load-file (expand-file-name "modeline.el" lisp-d))
;; (use-package ample-theme
;;   :ensure t
;;   :config
;;   (load-theme 'ample-flat t))
(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

;; Interface
(csetq inhibit-startup-screen t)
(csetq initial-scratch-message "")
(setq-default text-quoting-style 'grave)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(add-hook 'after-init-hook
          (lambda ()
            (setq frame-title-format
                  '(buffer-file-name
                    "%f"
                    (dired-directory dired-directory "%b")))))

(bind-key "C-x C-+" 'text-scale-increase)
(bind-key "C-x C--" 'text-scale-decrease)

;; Finding files
(csetq bookmark-default-file (expand-file-name "etc/bookmarks" emacs-d))
(csetq find-file-suppress-same-file-warnings t)
(prefer-coding-system 'utf-8)

(use-package dired
  :init
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  :commands dired
  :config
  (load-file (expand-file-name "dired.el" lisp-d))
  (bind-key "b" 'dired-open-file dired-mode-map)
  (bind-key "c" 'dired-open-fm dired-mode-map))

;; Minibuffer
(csetq echo-keystrokes "0.1")
(csetq savehist-file (expand-file-name "etc/savehist" emacs-d))
(csetq history-length 150)
(savehist-mode 1)

;; Regular expression builder
(use-package re-builder
  :bind (("C-c R" . re-builder))
  :config (setq reb-re-syntax 'string))

;; Editing
(setq-default indent-tabs-mode nil)
(defalias 'yes-or-no-p 'y-or-n-p)
(csetq delete-by-moving-to-trash t)
(csetq visible-bell t)
(setq-default indicate-empty-lines t)
(csetq set-mark-command-repeat-pop t)

(electric-pair-mode 1)
(blink-cursor-mode -1)
(show-paren-mode 1)
(column-number-mode 1)
(winner-mode 1)

(csetq windmove-wrap-around t)
(windmove-default-keybindings)

(csetq mouse-yank-at-point t)

(use-package transpose-frame :ensure t)

(load-file (expand-file-name "buffer.el" lisp-d))
(bind-key "C-x a b" 'create-scratch-buffer)

(bind-keys ("C-," . (lambda () (interactive) (other-window -1)))
           ("C-." . (lambda () (interactive) (other-window +1))))

(load-file (expand-file-name "editing.el" lisp-d))
(bind-key "C-c n" 'tidy-region-or-buffer)
(bind-key "C-x a r" 'align-regexp)

(bind-key "M-<up>"   'move-line-up)
(bind-key "M-<down>" 'move-line-down)

(bind-key "C-c +" 'my-increment-number-at-point)
(bind-key "C-c -" 'my-decrement-number-at-point)

;; Backups and saving
(let ((backup-dir (expand-file-name "backup/" emacs-d)))
  (csetq backup-directory-alist `((".*" . ,backup-dir)))
  (csetq auto-save-file-name-transforms `((".*" ,backup-dir t)))
  (unless (file-exists-p backup-dir)
    (make-directory backup-dir)))
(csetq vc-make-backup-files t)

(csetq save-place-file (expand-file-name "etc/saveplace" emacs-d))
(save-place-mode 1)

(use-package recentf
  :config
  (csetq recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG" "github.*txt$"
                           ".*png$" ".*cache$"))
  (csetq recentf-max-saved-items 60)
  (csetq recentf-save-file (expand-file-name "etc/recentf" emacs-d)))

;; Internal
(csetq gc-cons-threshold (* 10 1024 1024))

;; Help
(bind-key "C-i" 'info-display-manual 'help-command)
(bind-key "C-k" 'customize-apropos 'help-command)

;; Shell
(use-package shell
  :init (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
  :bind ("C-c s" . shell)
  :config
  (csetq comint-input-ignoredups t)
  (csetq comint-completion-addsuffix t)
  (csetq comint-completion-addsuffix t)
  (csetq comint-scroll-to-bottom-on-input t)
  (csetq comint-prompt-read-only t)
  (csetq comint-scroll-show-maximum-output t))

;; Completion
(use-package swiper
  :ensure t
  :init (ivy-mode 1)
  :diminish ivy-mode
  :bind (("C-s" . swiper)
         ("C-r" . swiper)
         ("C-c C-r" . ivy-resume)
         ("<f6>" . ivy-resume)
         ("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> l" . counsel-load-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-x l" . counsel-locate))
  :config
  (csetq ivy-use-virtual-buffers t)
  (use-package counsel
    :ensure t
    :config
    (setq-default counsel-git-grep-cmd "/home/jdahm/src/git/git --no-pager grep --full-name -n --no-color -i -e %S")
    (setq-default counsel-git-grep-cmd-history "/home/jdahm/src/git/git --no-pager grep --full-name -n --no-color -i -e %S")))

(use-package lispy
  :ensure t
  :init (add-hook 'emacs-lisp-mode-hook #'lispy-mode)
  :config
  (load-file (expand-file-name "abel.el" lisp-d)))

(use-package multiple-cursors
  :ensure t
  :bind ( ("C-S-c C-S-c" . mc/edit-lines)
          ("C->" . mc/mark-next-like-this)
          ("C-<" . mc/mark-previous-like-this)
          ("C-c C-<" . mc/mark-all-like-this)))

(use-package avy
  :ensure t
  :bind (("C-;" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g a" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)))

(use-package company
  :ensure t
  :diminish company-mode
  :init
  (add-hook 'prog-mode-hook #'company-mode))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init (add-hook 'prog-mode-hook #'flycheck-mode)
  :config
  (flycheck-define-checker proselint
    "A linter for prose."
    :command ("~/.local/bin/proselint" source-inplace)
    :error-patterns
    ((warning line-start (file-name) ":" line ":" column ": "
              (id (one-or-more (not (any " "))))
              (message) line-end))
    :modes (text-mode markdown-mode gfm-mode))
  (add-to-list 'flycheck-checkers 'proselint))

(use-package function-args
  :ensure t
  :init (fa-config-default)
  :config
  (bind-key (kbd "C-2") 'fa-show) function-args-mode-map)

(use-package compile
  :init
  ;; Close the compilation window if there was no error at all.
  (csetq compilation-exit-message-function
         (lambda (status code msg)
           ;; If M-x compile exists with a 0
           (when (and (eq status 'exit) (zerop code))
             ;; then bury the *compilation* buffer, so that C-x b doesn't go there
             (run-with-timer 1 nil
                             (lambda ()
                               (bury-buffer "*compilation*")
                               ;; and return to whatever were looking at before
                               (replace-buffer-in-windows "*compilation*"))))
           ;; Always return the anticipated result of compilation-exit-message-function
           (cons msg code))))

(use-package web-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode)))

;; Version control stuff
(use-package magit
  :ensure t
  ;; :defer t -- implied
  :commands magit-status
  :init (add-hook 'magit-mode-hook 'magit-load-config-extensions)
  :bind ("C-x g" . magit-status)
  :config
  (csetq magit-last-seen-setup-instructions "1.4.0")
  (csetq magit-status-buffer-switch-function 'switch-to-buffer))

(use-package ibuffer-vc
  :ensure t
  :bind ("C-x C-b" . ibuffer)
  :init
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'alphabetic)
                (ibuffer-do-sort-by-alphabetic)))))

(use-package git-timemachine :ensure t)

(use-package projectile
  :ensure t
  :commands projectile-compile-project
  :diminish projectile-mode
  ;; :config (projectile-global-mode)
  :bind ("C-c m" . projectile-compile-project))

;; (csetq paragraph-start "\f\\|[ \t]*$\\|[ \t]*[-+*] ")

(use-package octave
  :init (add-to-list 'auto-mode-alist '("\\.m$" . octave-mode)))

(use-package engine-mode
  :ensure t
  :config
  (engine-mode t)
  (csetq engine/browser-function 'browse-url-default-browser)
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")
  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "g")
  (defengine cppreference
    "http://en.cppreference.com/mwiki/index.php?search=%s"
    :keybinding "c")
  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "s"))

(use-package org
  :bind (("C-c c" . org-capture)
         ("C-c l" . org-store-link)
         ("C-c a" . org-agenda))
  :config
  (csetq org-modules '(org-habit))
  (csetq org-agenda-start-on-weekday 6) ; start weeks on Saturdays
  (csetq org-clock-idle-time 15)        ; idle time
  (csetq org-refile-targets '((nil :maxlevel . 1)
                              (org-agenda-files :maxlevel . 1))) ; flexible refiling

  (csetq org-todo-keywords
         '((sequence
            "TODO(t)"
            "STARTED(s)"
            "WAITING(w@/!)"
            "SOMEDAY(.)" "|" "DONE(x!)" "CANCELLED(c@)")
           (sequence "TODELEGATE(-)" "DELEGATED(d)" "COMPLETE(x)")
           (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")))

  (csetq org-latex-pdf-process (list "latexmk -lualatex -f %f"))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))

  (use-package org-present
    :ensure t
    :config
    (add-hook 'org-present-mode-hook
              (lambda ()
                (org-present-big)
                (org-display-inline-images)
                (org-present-hide-cursor)
                (org-present-read-only)))
    (add-hook 'org-present-mode-quit-hook
              (lambda ()
                (org-present-small)
                (org-remove-inline-images)
                (org-present-show-cursor)
                (org-present-read-write)))))

(use-package cc-mode
  :init
  (load-file (expand-file-name "cc.el" lisp-d))
  (add-hook 'c++-mode-hook (lambda ()
                             (c-set-style "stroustrup")
                             (c-set-offset 'namespace-open 0)
                             (c-set-offset 'namespace-close 0)
                             (c-set-offset 'innamespace 0))))

;; Load local customize files last
(if (file-readable-p local-init-file) (load-file local-init-file))

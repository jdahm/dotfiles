;;; init.el --- Initialization

;;; Commentary:

;;; Source: https://github.com/magnars/.emacs.d

;;; Code:

;; Top-level settings

;; Name/Email
(setq user-full-name    "Johann Dahm")
(setq user-mail-address "jdahm@fastmail.com")

;; Set up load path
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; Customization file here
(setq custom-file "~/.config/emacs/init-custom.el")

;; Turn off scrollbar, toolbar, etc. early for graphical mode in startup to
;; avoid window width weirdness
(when (display-graphic-p)
  (scroll-bar-mode -1)   ; disable the scroll bar
  (tool-bar-mode -1)     ; disable the awful toolbar
  )
(unless (display-graphic-p)
  (menu-bar-mode -1)    ; disable menu bar mode in terminal
  )

;; Frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; Persistence directory
(setq emacs-persistence-directory (concat user-emacs-directory "persistence/"))
(unless (file-exists-p emacs-persistence-directory)
  (make-directory emacs-persistence-directory t))

;; Highlight current line
(global-hl-line-mode 1)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Better defaults
(require 'sane-defaults)

;; Mac
(when (equal system-type 'darwin)
  (when (display-graphic-p)
    ;; Menu bar is not annoying in OSX
    (menu-bar-mode 1))

  ;; Make the browser the OS X default
  (setq browse-url-browser-function 'browse-url-default-macosx-browser))

;; External packages
(when (>= emacs-major-version 24)

  (require 'package)
  (defun packages-install (pkgs)
    (dolist (p pkgs)
      (when (not (package-installed-p p))
        (package-install p))))

  ;; Add melpa to package repos and initialize
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (package-initialize)
  (when (not package-archive-contents) (package-refresh-contents))

  ;; Install and require use-package to install everything else
  (packages-install '(use-package))
  (require 'use-package)

  ;; (use-package benchmark-init :ensure t)
  ;; (benchmark-init/activate)

  ;; Diminish is needed
  (use-package diminish :ensure t)

  ;; Themes (used in appearance)
  (use-package zenburn-theme :ensure t)
  (use-package solarized-theme :ensure t)

  ;; Appearance
  (use-package appearance
    :bind
    (("<f5>" . jdahm/toggle-color-theme))
    :init
    (progn
      (defvar jdahm/color-theme-dark 'zenburn "Dark color theme.")
      (defvar jdahm/color-theme-light 'solarized-light "Light color theme.")
      (defvar jdahm/color-theme jdahm/color-theme-dark "Default color theme.")
      (load-theme jdahm/color-theme t)))

  ;; Parens
  (electric-pair-mode 1)

  ;; Editing functions
  (use-package editing-defuns
    :bind
    (;; Existing functions
     ("C-c C-a" . auto-fill-mode)
     ("C-c w" . whitespace-mode)
     ("M-s l" . sort-lines)
     ;; Inside editing-functions.el
     ("M-z" . zap-up-to-char)
     ("M-Z" . zap-to-char)
     ("M-;" . comment-or-uncomment-region-or-line)
     ("C-a" . my-beginning-of-line)
     ("C-c M-w" . copy-line-or-region)
     ("C-c C-w" . kill-line-or-region)
     ("C-c n" . tidy-region)
     ("C-c C-n" . tidy-buffer)
     ("C-c t" . cycle-tab-width)
     ("C-x a r" . align-regexp)
     ("C-M-<up>". move-line-up)
     ("C-M-<down>" . move-line-down))
    :init
    (define-key 'help-command (kbd "C-i") 'info-display-manual))

  ;; Buffer functions
  (use-package buffer-defuns
    :bind
    (;; Existing functions
     ("C-c s" . shell)
     ("C-c S" . eshell)
     ("C-c r" . bury-buffer)
     ("C-c C-k" . eval-buffer)
     ("<f9>" . toggle-truncate-lines)
     ;; Inside buffer-defuns.el
     ("C-x k" . kill-current-buffer)
     ("C-c b" . create-scratch-buffer)
     ("C-x p" . prev-window)
     ("C-x -" . toggle-window-split)
     ("C-x C--" . rotate-windows)
     ("M-9" . switch-to-minibuffer-window)
     ("<f6>" . prev-buffer)
     ("<f7>" . split-window-show-prev)
     ("<f8>" . toggle-window-split))
    :init
    (global-unset-key (kbd "C-x C-+")))

  (use-package hidden-mode-line-mode)

  ;; Packages distributed with Emacs
  (use-package savehist
    :config
    (setq savehist-file (expand-file-name "saved-history" emacs-persistence-directory))
    :init (savehist-mode 1))

  (use-package savehist
    :config
    (setq save-place-file (expand-file-name "saved-places" emacs-persistence-directory))
    :init (setq-default save-place t))

  (use-package recentf
    :init
    (progn
      (setq recentf-max-saved-items 300 ; number of saved items
            recentf-auto-cleanup 600    ; cleanup when idle for 600 seconds
            )
      (when (not noninteractive) (recentf-mode 1))))

  (use-package windmove :init (windmove-default-keybindings))

  (use-package dired
    :config
    (progn
      (setq dired-recursive-copies 'always
            dired-recursive-deletes 'always
            delete-by-moving-to-trash t)
      (setq-default dired-listing-switches "-Al --si --time-style long-iso")
      ;; hide some details by default
      (add-hook 'dired-mode-hook 'dired-hide-details-mode)))

  (use-package octave :mode ("\\.m\\'" . octave-mode))

  (use-package python :mode "\\.py'" :interpreter ("python" . python-mode))

  (use-package ruby-mode :mode "\\.rb\\'" :interpreter "ruby")

  ;; External packages

  ;; Various useful modes
  (use-package markdown-mode
    :ensure t
    :mode (("\\.text\\'" . markdown-mode)
           ("\\.markdown\\'" . markdown-mode)
           ("\\.md\\'" . markdown-mode)))

  (use-package haskell-mode
    :ensure t
    :mode "\\.l?hs$"
    :config
    (progn
      (use-package inf-haskell)
      (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
      ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
      ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
      (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
      (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)))

  (use-package julia-mode :ensure t)

  ;; Git
  (use-package magit
    :ensure t
    :bind (("C-x g" . magit-status))
    :config
    (progn
      (use-package git-timemachine :ensure t)
      (use-package git-commit-mode :ensure t)
      (use-package git-rebase-mode :ensure t)
      (use-package gitconfig-mode :ensure t)
      (use-package gitignore-mode :ensure t)
      (setq magit-status-buffer-switch-function 'switch-to-buffer)
      (add-hook 'magit-mode-hook 'magit-load-config-extensions)))

  ;; Helm
  (use-package helm
    :ensure t
    :bind
    (("M-y" . helm-show-kill-ring)
     ("M-x" . helm-M-x)
     ("<f1>" . helm-resume)
     ("C-x C-b" . helm-buffers-list)
     ("C-x C-f" . helm-find-files)
     ("C-x C-m" . helm-M-x)
     ("C-x C-d" . helm-browse-project)
     ("C-x b" . helm-mini)
     ("C-x r j" . helm-register)
     ("C-x r b" . helm-filtered-bookmarks)
     ("C-c C-m" . helm-make)
     ("C-c m" . helm-make-projectile)
     ("C-c f" . helm-recentf)
     ("C-c <SPC>" . helm-all-mark-rings))
    :config
    (progn
      (use-package helm-ls-git :ensure t)
      (use-package helm-make :ensure t)
      (require 'helm-config)
      (setq helm-M-x-fuzzy-match t                   ; use fuzzy M-x matching
            helm-apropos-fuzzy-match t               ; use fuzzy matching for apropos
            helm-ls-git-status-command 'magit-status ; use Magit
            helm-truncate-lines t                    ; truncate lines in buffer by default
            helm-split-window-in-side-p t            ; open helm buffer inside current window
            )
      (define-key helm-command-map (kbd "g") 'helm-do-grep)
      (define-key helm-command-map (kbd "o") 'helm-occur)
      (define-key 'help-command (kbd "C-l") 'helm-locate-library)
      (define-key 'help-command (kbd "r") 'helm-info-emacs)
    ;; other commonly used definitions
      ;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
      ;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
      ;; (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
      ;; (define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
    ;; (define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)
      (use-package helm-eshell
        :config
        (add-hook 'eshell-mode-hook
                  #'(lambda ()
                      (define-key eshell-mode-map (kbd "C-c C-l") 'helm-eshell-history)))))
    :idle
    (progn
      (helm-mode 1)
      (diminish 'helm-mode " h")))
  
  (use-package org
    :ensure t
    :bind
    (("C-c c" . org-capture)
     ("C-c l" . org-store-link)
     ("C-c a" . org-agenda))

    :init
    (setq
     org-directory "~/Dropbox/org/"                                               ; directory for notes
     org-default-notes-file (concat org-directory "notes.org")                    ; default file
     org-agenda-files (list (concat org-directory "personal.org")
                            (concat org-directory "work.org"))                    ; agenda files
     org-archive-location "~/Dropbox/org/datetree.org::datetree/* Finished Tasks" ; archive format
     )

    :config
    (progn
      (setq
       org-modules '(org-habit)                               ; modules for org-mode
       org-agenda-start-on-weekday 6                          ; start weeks on Saturdays
       org-refile-targets '((nil :maxlevel . 1)
                            (org-agenda-files :maxlevel . 1)) ; flexible refiling
       )
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

      (setq org-latex-pdf-process (list "latexmk -lualatex -f %f"))))

  (use-package org-present
    :ensure t
    :config
    (progn
      (add-hook 'org-present-mode-hook
                (lambda ()
                  (org-present-big)
                  (org-display-inline-images)
                  (org-present-hide-cursor)
                  (global-hl-line-mode nil)
                  (org-present-read-only)))
      (add-hook 'org-present-mode-quit-hook
                (lambda ()
                  (org-present-small)
                  (org-remove-inline-images)
                  (global-hl-line-mode 1)
                  (org-present-show-cursor)
                  (org-present-read-write)))))

  ;; Compiling
  (use-package flycheck
    :ensure t
    :diminish " f"
    :bind (("C-c y" . flycheck-mode))
    :init (add-hook 'after-init-hook #'global-flycheck-mode))

  ;; Editing
  (use-package expand-region
    :ensure t
    :bind (("C-=" . er/expand-region)
           ("C-M-=" . er/contract-region)))

  (use-package change-inner
    :ensure t
    :bind
    (("M-i" . change-inner)
     ("M-o" . change-outer)))

  (use-package multiple-cursors
    :ensure t
    :bind (("C-S-c C-S-c" . mc/edit-lines)
           ("C->" . mc/mark-next-like-this)
           ("C-<" . mc/mark-previous-like-this)
           ("C-c C-<" . mc/mark-all-like-this)))

  (use-package jump-char
    :ensure t
    :bind
    (("M-m" . jump-char-forward)
     ("M-S-m" . jump-char-backward)))

  ;; News
  (use-package elfeed
    :ensure t
    :bind
    ("C-x w" . elfeed))

  ;; (benchmark-init/deactivate)

  ;; Disabled external packages
  ;; (use-package twittering-mode :disabled t)
  ;; (use-package cmake-mode :disabled t :mode "\\.cmake\\'")
  )

;; Load customization file last
(if (file-readable-p custom-file) (load custom-file))

(provide 'init)

;;; init.el ends here

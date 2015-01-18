;;; init.el --- Initialization

;;; Commentary:

;;; Source: https://github.com/magnars/.emacs.d

;;; Code:

;; Top-level settings

;; Name/Email
(setq user-full-name    "Johann Dahm")
(setq user-mail-address "johann.dahm@gmail.com")

;; Set up load path
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; Local customization file
(setq custom-file "~/.config/emacs/init-custom.el")
(if (file-readable-p custom-file) (load custom-file))

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

;; Save buffer history
(require 'savehist)
(setq savehist-file (expand-file-name "saved-history" emacs-persistence-directory))
(savehist-mode 1)

;; Save place in buffer
(require 'saveplace)
(setq save-place-file (expand-file-name "saved-places" emacs-persistence-directory))
(setq-default save-place t)

;; Save recently opened files
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

;; Better window selection
(require 'windmove)
(windmove-default-keybindings)

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

;; If this is an older Emacs, it will stop here

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

  ;; Diminish is needed
  (use-package diminish :ensure t)

  ;; Themes (used in appearance)
  (use-package zenburn-theme :ensure t)

  ;; Apearance
  (use-package appearance
    :bind
    (("<f6>" . jdahm/toggle-color-theme)))

  ;; Parens
  (electric-pair-mode 1)

  ;; Keybindings to existing commands
  (global-set-key (kbd "C-c s") 'shell)
  (global-set-key (kbd "C-c r") 'bury-buffer)
  (global-set-key (kbd "C-c C-a") 'auto-fill-mode)
  (global-set-key (kbd "C-c w") 'whitespace-mode)

  (global-set-key (kbd "C-c C-k") 'eval-buffer)

  (global-set-key (kbd "M-s l") 'sort-lines)

  (global-set-key (kbd "<f9>") 'toggle-truncate-lines)

  (define-key 'help-command (kbd "C-i") 'info-display-manual)

  ;; Editing functions
  (use-package editing-defuns
    :bind
    (("C-a" . my-beginning-of-line)
     ("C-c t" . cycle-tab-width)
     ("C-c n" . tidy-region)
     ("C-c C-n" . tidy-buffer)
     ("C-c b" . create-scratch-buffers)
     ("C-x a r" . align-regexp)
     ("M-z" . zap-up-to-char)
     ("M-;" . comment-or-uncomment-region-or-line)
     ("C-M-<up>". move-line-up)
     ("C-M-<down>" . move-line-down)))

  ;; Buffer functions
  (use-package buffer-defuns
    :bind
    (("C-x k" . kill-current-buffer)
     ("C-x p" . prev-buffer)
     ("C-x -" . toggle-window-split)
     ("C-x C--" . rotate-windows)
     ("M-n" . other-window)
     ("M-p" . prev-window)
     ("M-9" . switch-to-minibuffer-window)
     ("<f7>" . split-window-show-prev)
     ("<f8>" . toggle-window-split))
    :init
    (global-unset-key (kbd "C-x C-+")))

  (use-package hidden-mode-line-mode)

  ;; Packages distributed with Emacs
  (use-package octave
    :init
    (add-to-list 'auto-mode-alist '("\\.m$\\'" . octave-mode)))

  (use-package org
    :bind
    (("C-c c" . org-capture)
     ("C-c l" . org-store-link)
     ("C-c a" . org-agenda))

    :init
    (progn
      (setq
       org-directory "~/Dropbox/org/"  ; default directory for notes
       org-default-notes-file (concat org-directory "notes.org") ; default target file for notes
       org-agenda-start-on-weekday 6 ; start weeks on Saturdays
       )

      (setq org-agenda-files (list (concat org-directory "personal.org")
                                   (concat org-directory "work.org"))))

    :config
    (progn
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
              (sequence "REPORT(r)" "BUG(b)" "KNOWNCAUSE(k)" "|" "FIXED(f)")))))

  (use-package org-present
    :ensure t
    :config
    (progn
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

  (use-package dired
    :config
    (progn
      (setq dired-recursive-copies 'always
            dired-recursive-deletes 'always)
      (setq-default dired-listing-switches "-Al --si --time-style long-iso")
      ;; hide some details by default
      (add-hook 'dired-mode-hook 'dired-hide-details-mode)))

  ;; External packages
  (use-package markdown-mode
    :ensure t
    :init
    (progn
      (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
      (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
      (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))))

  (use-package haskell-mode
    :ensure t
    :config
    (progn
      (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
      ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
      ;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
      (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
      (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)))

  (use-package helm-config
    :ensure helm
    :diminish helm-mode
    :bind
    (("M-y" . helm-show-kill-ring)
     ("M-x" . helm-M-x)
     ("C-x C-m" . helm-M-x)
     ("C-x C-f" . helm-find-files)
     ("C-x b" . helm-mini)
     ("C-c f" . helm-recentf)
     ("C-c h" . helm-command-prefix))
    :init
    (global-unset-key (kbd "C-x c"))
    :config
    (progn
      (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
      (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
      (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
      (define-key helm-command-map (kbd "g") 'helm-do-grep)
      (define-key helm-command-map (kbd "o") 'helm-occur)
      (define-key 'help-command (kbd "C-l") 'helm-locate-library)
      (define-key 'help-command (kbd "r") 'helm-info-emacs)
      (define-key 'help-command (kbd "f") 'helm-apropos))
    :idle helm-mode
    :diminish " h")

  (use-package projectile
    :ensure t
    :init (projectile-global-mode)
    :config (setq projectile-enable-caching t)
    :diminish " p")

  (use-package helm-projectile
    :ensure t
    :bind (("C-x f" . helm-projectile)
           ("C-c p f" . helm-projectile-find-file)
           ("C-c p s" . helm-projectile-switch-project)))

  (use-package magit
    :ensure t
    :bind (("C-x g" . magit-status))
    :config
    (progn
      (setq magit-status-buffer-switch-function 'switch-to-buffer)
      (add-hook 'magit-mode-hook 'magit-load-config-extensions)))

  (use-package git-timemachine :ensure t)

  (use-package flycheck
    :ensure t
    :bind (("C-c y" . flycheck-mode))
    :init (add-hook 'after-init-hook #'global-flycheck-mode)
    :diminish " f")

  (use-package expand-region
    :ensure t
    :bind (("C-'" . er/expand-region)
           ("C-M-'" . er/contract-region)))

  (use-package change-inner
    :ensure t
    :bind
    ;; vim's ci and co commands (change-inner settings)
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
     ("M-S-m" . jump-char-backward))))

(provide 'init)

;;; init.el ends here

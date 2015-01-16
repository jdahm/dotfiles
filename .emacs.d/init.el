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

;; Start with some better defaults
(require 'sane-defaults)

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

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

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

;; Mac
(when (equal system-type 'darwin)
  (when (display-graphic-p)
    ;; Menu bar is not annoying in OSX
    (menu-bar-mode 1))

  ;; Make the browser the OS X default
  (setq browse-url-browser-function 'browse-url-default-macosx-browser))

(defvar jdahm/pkgs
  '(;; Modes
    markdown-mode
    haskell-mode
    ;; Project and modeline
    projectile
    flycheck
    flx-ido
    smex
    diminish
    ;; Git
    magit
    git-timemachine
    ;; Editing
    expand-region
    change-inner
    multiple-cursors
    yasnippet
    ;; Movement
    jump-char
    ;; Extra
    elfeed
    org-present
    ))

;; External packages
(when (>= emacs-major-version 24)

  ;; Initialize package repository
  (require 'setup-package)

  ;; Ensure packages are installed
  (packages-install jdahm/pkgs)

  ;; Apearance
  (require 'appearance)

  ;; Keys
  (require 'keybindings)

  ;; Some additional functions
  (require 'editing-defuns)
  (require 'buffer-defuns)

  ;; Markdown
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

  ;; Initialize smex
  (smex-initialize)

  ;; Projectile
  (projectile-global-mode)
  (setq projectile-completion-system 'ido)
  (setq projectile-enable-caching t)

  ;; Magit
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)

  ;; Org-mode setup
  (require 'setup-org)

  ;; Ido
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil)

  ;; Dired
  (require 'dired)
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq-default dired-listing-switches "-Al --si --time-style long-iso")

  ;; Haskell
  (require 'setup-haskell)

  ;; Octave/Matlab
  (add-to-list 'auto-mode-alist '("\\.m$\\'" . octave-mode))

  ;; Parens
  (electric-pair-mode 1)

  ;; Snippets
  (require 'setup-yasnippet)

  ;; Hidden mode-line mode
  (require 'hidden-mode-line-mode)

  ;; Hide modes
  (require 'hide-modes))

(provide 'init)

;;; init.el ends here

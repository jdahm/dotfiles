;;; init.el --- Initialization

;;; Commentary:

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

;; A few functions
(require 'utils)

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

;; Mac
(when (equal system-type 'darwin)
  (when (display-graphic-p)
    ;; Menu bar is not annoying in OSX
    (menu-bar-mode 1))

  ;; Make the browser the OS X default
  (setq browse-url-browser-function 'browse-url-default-macosx-browser))

;; External packages
(when (>= emacs-major-version 24)
  ;; External packages
  (require 'package)
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize)
  (when (not package-archive-contents)
    (package-refresh-contents))

  (defvar my-packages
    '(;; Modes
      markdown-mode
      d-mode
      clojure-mode
      haskell-mode
      ;; Project and modeline
      smex
      diminish
      flycheck
      projectile
      flx-ido
      ;; Git
      magit
      git-timemachine
      ;; Editing
      expand-region
      multiple-cursors
      smartparens
      ;; Extra
      elfeed
      org-present
      ))
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p)))

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

  ;; Hide modes
  (require 'hide-modes)

  ;; Keys
  (require 'keybindings)

  ;; Haskell
  (require 'setup-haskell)

  ;; Octave/Matlab
  (add-to-list 'auto-mode-alist '("\\.m$\\'" . octave-mode))

  ;; smartparens
  (require 'smartparens-config)
  (smartparens-global-mode 1)

  ;; Easily navigate sillycased words
  (global-subword-mode 1)

  ;; Colors/Theme
  (jdahm/color-theme-init)
  (load-theme jdahm/color-theme-type t))


(provide 'init)

;;; init.el ends here

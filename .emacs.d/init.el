;;; init.el --- Initialization

;;; Commentary:

;;; Code:

;; Top-level settings

;; Name/Email
(setq user-full-name    "Johann Dahm")
(setq user-mail-address "jdahm@fastmail.com")

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

;; Better window selection
(require 'windmove)
(windmove-default-keybindings)

;; Mac
(when (equal system-type 'darwin)
  ;; Menu bar is not annoying in OSX
  (menu-bar-mode 1)

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
    '(markdown-mode
      d-mode
      clojure-mode
      haskell-mode
      flycheck
      projectile
      magit
      flx-ido
      elfeed
      org-present
      diminish
      ))
  (dolist (p my-packages)
    (when (not (package-installed-p p))
      (package-install p)))

  ;; Markdown
  (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
  (setq-default markdown-indent-on-enter nil)

  ;; Projectile
  (projectile-global-mode)
  (setq projectile-completion-system 'ido)
  (setq projectile-enable-caching t)

  ;; Magit
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)

  ;; Flycheck

  ;; Org-mode setup
  (require 'setup-org)

  ;; Ido
  (require 'flx-ido)
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
  (setq-default dired-listing-switches "-alh")

  ;; Colors/Theme
  (load-theme 'wombat t)

  ;; Hide modes
  (require 'hide-modes)

  ;; Keys
  (require 'keybindings))

(provide 'init)

;;; init.el ends here

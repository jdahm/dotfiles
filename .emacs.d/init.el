;;; init.el --- Initialization

;;; Commentary:

;;; My init.el file.

;;; Code:

;; Top-level settings

;; Name/Email
(setq user-full-name    "Johann Dahm")
(setq user-mail-address "jdahm@fastmail.com")

;; Set up load path
(add-to-list 'load-path (concat user-emacs-directory "elisp/"))

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

;; Start with some sanity
(require 'sane-defaults)

;; A few functions
(require 'defuns)


;; Setup built-in, standard, packages

;; Save backup files to dedicated folder
(setq backup-directory-alist '(("." . "~/.emacs.d/saves")))

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


;; Clean modeline
(defvar mode-line-cleaner-alist
  `((auto-complete-mode . " α")
    (paredit-mode . " π")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (subword-mode . " σ")
    (projectile-mode . " φ")
    ;; Major modes
    (dired-mode . "Δ")
    (lisp-interaction-mode . "Λ")
    (python-mode . "Py")
    (emacs-lisp-mode . "EL")))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)


;; Mac
(when (equal system-type 'darwin)
  ;; Menu bar is not annoying in OSX
  (menu-bar-mode 1)

  ;; Make the browser the OS X default
  (setq browse-url-browser-function 'browse-url-default-macosx-browser))


;; Keys
(global-set-key (kbd "C-a")   'my-beginning-of-line)

(global-set-key (kbd "C-c C-a") 'auto-fill-mode)
(global-set-key (kbd "C-c C-w") 'whitespace-mode)
(global-set-key (kbd "C-c w")   'my-toggle-show-trailing-whitespace)
(global-set-key (kbd "C-c s")   'shell)
(global-set-key (kbd "C-c \\")  'align-regexp)
(global-set-key (kbd "C-c t")   'my-tab-width)

(global-set-key (kbd "C-x C-u") 'my-url-insert-file-contents)
(global-set-key (kbd "C-x C-q") 'toggle-read-only)

(global-set-key (kbd "M-<up>")   (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "M-<down>") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "M-9")      'my-switch-to-minibuffer-window)

(global-set-key (kbd "<f6>") 'my-prev-buffer)
(global-set-key (kbd "<f7>") 'my-split-window)
(global-set-key (kbd "<f8>") 'my-toggle-window-split)
(global-set-key (kbd "<f9>") 'toggle-menu-bar-mode-from-frame)

(define-key emacs-lisp-mode-map (kbd "M-.") 'find-function-at-point)


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
  (add-to-list 'projectile-globally-ignored-files ".DS_Store")

  ;; Magit
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)
  (global-set-key (kbd "C-x g")   'magit-status)

  ;; Flycheck
  (global-set-key (kbd "C-c f")   'flycheck-mode)

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
  (setq dired-listing-switches "-Al --si --time-style long-iso --group-directories-first")

  ;; Colors/Theme
  (load-theme 'wombat t)

  ;; Frame title
  (setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b")))))

(provide 'init)

;;; init.el ends here

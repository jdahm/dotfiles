;;; init.el --- Initialization

;;; Commentary:

;;; My init.el file.

;;; Code:

;; Early settings

;; Name/Email
(setq user-full-name    "Johann Dahm")
(setq user-mail-address "jdahm@fastmail.com")

;; Turn off scrollbar, toolbar, etc. early for graphical mode in startup to
;; avoid window width weirdness
(when (display-graphic-p)
  (scroll-bar-mode -1)   ; disable the scroll bar
  (tool-bar-mode -1)     ; disable the awful toolbar
  )
(unless (display-graphic-p)
  (menu-bar-mode -1)    ; disable menu bar mode in terminal
  )

;; Set up load path
(add-to-list 'load-path (concat user-emacs-directory "elisp/"))

;; Local customization file
(setq custom-file "~/.config/emacs/init-custom.el")
(if (file-readable-p custom-file) (load custom-file))

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; Start with some sanity
(require 'sane-defaults)

;; A few functions
(require 'defuns)

;; Save backup files to dedicated folder
(setq backup-directory-alist '(("." . "~/.emacs.d/saves")))

;; Persistence directory
(setq emacs-persistence-directory (concat user-emacs-directory "persistence/"))
(unless (file-exists-p emacs-persistence-directory)
  (make-directory emacs-persistence-directory t))


;; Mac
(when is-mac
  ;; Menu bar is not annoying in OSX
  (menu-bar-mode 1)

  ;; Use GNU ls if found
  (if (executable-find "gls")
      (setq insert-directory-program "gls"))

  ;; Make the browser the OS X default
  (setq browse-url-browser-function 'browse-url-default-macosx-browser))


;; Octave

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


;;; Setup built-in, standard, packages
(require 'savehist)
(setq savehist-file (expand-file-name "saved-history" emacs-persistence-directory))
(savehist-mode 1)

(require 'saveplace)
(setq save-place-file (expand-file-name "saved-places" emacs-persistence-directory))
(setq-default save-place t)

(require 'windmove)
(windmove-default-keybindings)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


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
  ;; Colors/Theme
  (load-theme 'wombat t)

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
  (setq projectile-mode-line '(:eval (format " Proj[%s]" (projectile-project-name))))
  (add-to-list 'projectile-globally-ignored-files ".DS_Store")

  ;; Magit
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  (global-set-key (kbd "C-c g")   'magit-status)
  (global-set-key (kbd "C-c l")   'magit-log)

  ;; Flycheck
  (global-set-key (kbd "C-c f")   'flycheck-mode)

  ;; Org-mode setup
  (with-eval-after-load "org" (require 'setup-org))

  ;; Ido
  (require 'flx-ido)
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(provide 'init)

;;; init.el ends here

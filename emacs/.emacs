;;; .emacs --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann.dahm@gmail.com>
;;
;;; Commentary:
;;
;; Configuration for Emacs. Requires Emacs 24 for package.el.
;;
;; Sources:
;;   * sjrmanning/.emacs.d
;;   * magnars/.emacs.d
;;   * muahah/emacs-profile
;;
;;; Code:

(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))
(defconst backup-d (expand-file-name "backups/" user-emacs-directory))

;; Set package archives and initialize
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/"))
(setq package-enable-at-startup nil)
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Some extra functions
(require 'jd-extra)

;; Complement to C-x o
(global-set-key (kbd "C-x p") (lambda () (interactive) (other-window -1)))

(autoload 'ibuffer "ibuffer" "ibuffer mode" t)
(global-set-key (kbd "C-x C-b") #'ibuffer)

(require-package 'ibuffer-tramp)
(require-package 'ibuffer-vc)

(with-eval-after-load "ibuffer"
  (define-key ibuffer-mode-map (kbd "s r") #'ibuffer-tramp-set-filter-groups-by-tramp-connection)
  (define-key ibuffer-mode-map (kbd "s g") #'ibuffer-vc-set-filter-groups-by-vc-root)
  (add-hook 'ibuffer-hook
	    (lambda ()
	      (ibuffer-vc-set-filter-groups-by-vc-root)
	      (unless (eq ibuffer-sorting-mode 'alphabetic)
		;; (ibuffer-do-sort-by-alphabetic))))
		(ibuffer-do-sort-by-vc-status)))))

(global-set-key (kbd "C-x C-a") #'align-regexp)
(global-set-key (kbd "C-M-\\") #'tidy-region-or-buffer)
(global-set-key (kbd "C-c s") #'eshell)

;; Editing
(global-set-key (kbd "M-Q") #'unfill-paragraph)

;; This overwrites `comment-set-column', but that is rarely used and
;; the default binding for comment-line is not terminal-friendly.
(global-set-key (kbd "C-x ;") #'comment-line)

(global-set-key (kbd "C-c +") #'inc-number-at-point)
(global-set-key (kbd "C-c -") #'dec-number-at-point)

;; Recentf
(global-set-key (kbd "C-M-r") #'recentf-open-files)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(global-set-key (kbd "C-x C-j") #'dired-jump)
(global-set-key (kbd "C-x 4 C-j") #'dired-jump-other-window)
(setq-default dired-recursive-copies 'always
              dired-recursive-deletes 'top)
(autoload #'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload #'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(with-eval-after-load "dired"
  (define-key dired-mode-map "b" #'dired-open-file)
  (define-key dired-mode-map "c" #'dired-open-fm)
  (define-key dired-mode-map "Q" #'dired-do-query-replace-regexp))

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

;; Text and Web
(require-package 'olivetti)

(require-package 'markdown-mode)
(setq markdown-command "multimarkdown")
(dolist (item '(("README\\.md\\'" . gfm-mode)
                ("\\.md\\'" . markdown-mode)
                ("\\.markdown\\'" . markdown-mode)))
  (add-to-list 'auto-mode-alist item))

(require-package 'web-mode)
(dolist (item '(("\\.html?\\'" . web-mode)
                ("\\.css?\\'" . web-mode)))
  (add-to-list 'auto-mode-alist item))

;; Compile
(global-set-key (kbd "<f9>") #'compile)

;; Flyspell
(require 'flyspell)
(add-hook 'text-mode-hook #'turn-on-flyspell)
(with-eval-after-load "flyspell"
  (define-key flyspell-mode-map (kbd "<C-f12>") 'flyspell-goto-next-error))
(with-eval-after-load "auto-complete" (ac-flyspell-workaround))

;; Org
(require-package 'org-plus-contrib)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c c") #'org-capture)
(global-set-key (kbd "C-c a") #'org-agenda)
(add-hook 'org-mode-hook #'turn-on-visual-line-mode)
(add-hook 'org-mode-hook #'turn-on-flyspell)

(defconst jd-default-notes-file "~/Documents/todo.org")
(defconst jd-diary-file "~/Documents/diary.org")

;; Auctex
(require-package 'auctex)
(require-package 'auctex-latexmk)
(auctex-latexmk-setup)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (LaTeX-math-mode 1)
            (reftex-mode 1)))

;; Git
(require-package 'hl-todo)
(require-package 'magit)
(global-set-key (kbd "C-x g") #'magit-status)
(add-hook 'magit-update-uncommitted-buffer-hook 'vc-refresh-state)

;; Programming
(define-key prog-mode-map (kbd "M-`") #'imenu)
(global-set-key (kbd "M-o") #'ff-find-other-file)

;; C/C++
(require-package 'modern-cpp-font-lock)
(add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)

;; Dont indent namespaces by default
(c-set-offset 'innamespace 0)

;; Source: http://endlessparentheses.com/the-toggle-map-and-wizardry.html
(define-prefix-command 'jd/toggle-map)
;; The manual recommends C-c for user keys, but C-x t is
;; always free, whereas C-c t is used by some modes.
(define-key ctl-x-map "t" 'jd/toggle-map)
(define-key jd/toggle-map "c" #'column-number-mode)
(define-key jd/toggle-map "d" #'toggle-debug-on-error)
(define-key jd/toggle-map "f" #'auto-fill-mode)
(define-key jd/toggle-map "t" #'toggle-truncate-lines)
(define-key jd/toggle-map "l" #'linum-mode)
(define-key jd/toggle-map "s" #'subword-mode)
(define-key jd/toggle-map "S" #'superword-mode)
(define-key jd/toggle-map "q" #'toggle-debug-on-quit)
;;; Generalized version of `read-only-mode'.
(define-key jd/toggle-map "r" #'dired-toggle-read-only)
(autoload 'dired-toggle-read-only "dired" nil t)
(define-key jd/toggle-map "w" #'whitespace-mode)
(define-key jd/toggle-map "|" #'toggle-window-split)

;; Whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Tramp ssh control is correctly setup in ~/.ssh/config
;; Source: https://lists.gnu.org/archive/html/help-gnu-emacs/2013-04/msg00323.html
(setq tramp-ssh-controlmaster-options "")

;; Shell
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; Conf mode for .job files
(add-to-list 'auto-mode-alist '("\\.job\\'" . conf-mode))

;; c-mode for okl
(add-to-list 'auto-mode-alist '("\\.okl\\'" . c-mode))

;; Other modes
(require-package 'cmake-mode)
(require-package 'cuda-mode)
(require-package 'rust-mode)

;; Theme
(require-package 'doom-themes)

(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Fancy titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(add-hook 'after-init-hook
          (lambda ()
            (setq frame-title-format
                  '(buffer-file-name
                    "%f"
                    (dired-directory dired-directory "%b")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-auto-save nil)
 '(TeX-engine (quote luatex))
 '(TeX-parse-self t)
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(backup-by-copying t)
 '(backup-directory-alist (\` (("." \, backup-d))))
 '(blink-cursor-mode nil)
 '(bury-successful-compilation-precompile-window-state t)
 '(bury-successful-compilation-save-windows t)
 '(c-default-style
   (quote
    ((java-mode . "java")
     (awk-mode . "awk")
     (other . "bsd"))))
 '(column-number-mode t)
 '(comint-input-ignoredups t)
 '(comint-prompt-read-only t)
 '(comint-scroll-show-maximum-output nil)
 '(comint-scroll-to-bottom-on-input (quote all))
 '(compilation-message-face (quote default))
 '(compilation-scroll-output (quote first-error))
 '(custom-enabled-themes (quote (doom-one)))
 '(custom-safe-themes
   (quote
    ("2af26301bded15f5f9111d3a161b6bfb3f4b93ec34ffa95e42815396da9cb560" "bfdcbf0d33f3376a956707e746d10f3ef2d8d9caa1c214361c9c08f00a1c8409" default)))
 '(delete-by-moving-to-trash t)
 '(delete-old-versions t)
 '(ediff-cmp-options (quote ("-w")))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(enable-remote-dir-locals t)
 '(fci-rule-color "#383838")
 '(ibuffer-saved-filter-groups nil)
 '(ibuffer-saved-filters
   (quote
    (("only-files"
      ((not mode . dired-mode)
       (name . "^[^*]")))
     ("gnus"
      ((or
        (mode . message-mode)
        (mode . mail-mode)
        (mode . gnus-group-mode)
        (mode . gnus-summary-mode)
        (mode . gnus-article-mode))))
     ("programming"
      ((or
        (mode . emacs-lisp-mode)
        (mode . cperl-mode)
        (mode . c-mode)
        (mode . java-mode)
        (mode . idl-mode)
        (mode . lisp-mode)))))))
 '(ibuffer-use-other-window t)
 '(indent-tabs-mode nil)
 '(initial-scratch-message "")
 '(ispell-program-name "/usr/local/bin/aspell")
 '(midnight-mode t)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-agenda-files jd-default-notes-file)
 '(org-capture-templates
   (quote
    (("t" "Todo" entry
      (file org-default-notes-file)
      "* TODO %?\\n%u\\n%a\\n")
     ("m" "Meeting" entry
      (file org-default-notes-file)
      "* MEETING with %? :MEETING:
%t")
     ("d" "Diary" entry
      (file+datetree jd-diary-file))
     ("i" "Idea" entry
      (file org-default-notes-file)
      "* %? :IDEA: \\n%t")
     ("n" "Next Task" entry
      (file+headline org-default-notes-file "Tasks")
      "** NEXT %?
DEADLINE: %t"))))
 '(org-clock-idle-time 45)
 '(org-default-notes-file jd-default-notes-file)
 '(org-directory "~/org/")
 '(org-log-done (quote time))
 '(package-selected-packages
   (quote
    (doom-themes hl-todo org-plus-contrib bbdb olivetti magit cuda-mode rust-mode cmake-mode ibuffer-vc ibuffer-tramp modern-cpp-font-lock web-mode markdown-mode)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(recentf-max-menu-items 25)
 '(recentf-mode t)
 '(savehist-mode t)
 '(scroll-bar-mode nil)
 '(sentence-end-double-space nil)
 '(set-mark-command-repeat-pop t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(use-dialog-box nil)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(version-control t)
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 130 :family "Iosevka Term")))))

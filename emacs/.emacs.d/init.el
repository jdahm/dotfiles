;;; init.el --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann@jdahm.me>
;;
;;; Commentary:
;;
;; Configuration for Emacs
;;
;;; Code:

(defconst config-d "~/.config/emacs/")
(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))

;; Set package archives and initialize
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Load core functions
(require 'jd-defuns)

;; Character encodings default to utf-8
(prefer-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Precaution: Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Enable y/n answers
(defalias 'yes-or-no-p 'y-or-n-p)

;; ring-bell-function = `invert-face' on modeline
(setq visible-bell nil)
(setq ring-bell-function (lambda ()
			   (invert-face 'mode-line)
			   (run-with-timer 0.1 nil 'invert-face 'mode-line)))

;; Add useful functions to help-map
(define-key help-map "\C-i" 'info-display-manual)
(define-key help-map "\C-s" 'customize-apropos)

;; Replace and add a few critical functions
(require 'jd-buffer)
(global-set-key (kbd "C-x a b") 'create-scratch-buffer)
(global-set-key (kbd "C-x k") 'kill-current-buffer)

(require 'jd-editing)
(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "C-c n") 'tidy-region-or-buffer)
(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)
(global-set-key (kbd "M-Q") 'unfill-paragraph)
(global-set-key (kbd "C-c +") 'increment-number-at-point)
(global-set-key (kbd "C-c -") 'decrement-number-at-point)

;; Let C-w execute `backward-kill-word' when region is not active
(defadvice kill-region (before unix-werase activate compile)
      "When called interactively with no active region, delete a single word
    backwards instead."
      (interactive
       (if mark-active (list (region-beginning) (region-end))
         (list (save-excursion (backward-word 1) (point)) (point)))))

;; Dired
(require 'jd-dired)
(require 'dired)
(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-x 4 C-j") 'dired-jump-other-window)
(define-key dired-mode-map (kbd "C-c C-s") 'sudired)
(define-key dired-mode-map "b" 'dired-open-file)
(define-key dired-mode-map "c" 'dired-open-fm)

(setq-default dired-clean-up-buffers-too t)
(setq-default dired-recursive-copies 'always)
(setq-default dired-recursive-deletes 'top)

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)
(global-set-key (kbd "C-c s") 'eshell)
(global-set-key (kbd "C-c S") 'shell)

;; Vkill
(autoload 'vkill "vkill" nil t)
(autoload 'list-unix-processes "vkill" nil t)

;; Ivy and Avy
(require 'diminish)
(require-package 'ivy)
(require-package 'counsel)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-c i") 'counsel-imenu)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c L") 'counsel-git-log)
(global-set-key (kbd "C-c u") 'counsel-unicode-char)
(global-set-key (kbd "C-c l") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(define-key lisp-mode-shared-map "\M-i" 'counsel-el)

(ivy-mode 1)
(diminish 'ivy-mode)

(counsel-mode 1)
(diminish 'counsel-mode)

;; Go to swiper from isearch
(define-key isearch-mode-map (kbd "M-i") 'swiper-from-isearch)

;; Could also use entirely swiper instead of isearch
;; (global-set-key (kbd "C-s") 'counsel-grep-or-swiper)
;; (global-set-key (kbd "C-r") 'swiper)

(require-package 'avy)
(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g a") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)
(global-set-key (kbd "C-M-s") 'avy-goto-char-timer)

(require-package 'tiny)
(global-set-key (kbd "C-M-;") 'tiny-expand)

(require-package 'iedit)
(global-set-key (kbd "C-c ;") 'iedit-mode)

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

;; Version-control
(require-package 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

(require-package 'git-timemachine)
(global-set-key (kbd "C-x v t") 'git-timemachine)

(require-package 'ibuffer-vc)
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              ;; (ibuffer-do-sort-by-alphabetic))))
              (ibuffer-do-sort-by-vc-status))))
(global-set-key (kbd "C-x C-b") 'ibuffer)

(require-package 'hydra)
(global-set-key (kbd "M-p") 'bookmark-jump)

(require-package 'ace-link)
(ace-link-setup-default)

;; Global `compile' keybinding
(global-set-key (kbd "C-c m") 'compile)

;; Better manage window layouts with winner-mode.
(winner-mode 1)
(require-package 'hydra)
(defhydra hydra-window ()
  "window"
  ("h" windmove-left "left")
  ("j" windmove-down "down")
  ("k" windmove-up "up")
  ("l" windmove-right "right")
  ("n" winner-undo "undo")
  ("p" winner-redo "redo")
  ("m" bookmark-jump "bmk"))
(global-set-key (kbd "C-x w") 'hydra-window/body)

(defhydra hydra-next-error (global-map "C-x")
  "
Compilation errors:
_j_: next error        _h_: first error    _q_uit
_k_: previous error    _l_: last error
"
  ("`" next-error     nil)
  ("j" next-error     nil :bind nil)
  ("k" previous-error nil :bind nil)
  ("h" first-error    nil :bind nil)
  ("l" (condition-case err
           (while t
             (next-error))
         (user-error nil))
   nil :bind nil)
  ("q" nil            nil :color blue))

(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

(require 'jd-cc)
(add-hook 'c++-mode-hook (lambda ()
                           (c-set-style "stroustrup")
                           (c-set-offset 'namespace-open 0)
                           (c-set-offset 'namespace-close 0)
                           (c-set-offset 'innamespace 0)))
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(define-key prog-mode-map (kbd "C-c t") 'tags-search)

;; (require-package 'company)
;; (add-hook 'after-init-hook #'global-company-mode)

(setq custom-file (expand-file-name "custom.el" config-d))
(if (file-readable-p custom-file) (load-file custom-file))

;;; init.el ends here

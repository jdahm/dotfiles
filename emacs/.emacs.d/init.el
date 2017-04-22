;;; init.el --- Configuration for Emacs
;;
;;; Author: Johann Dahm <johann.dahm@gmail.com>
;;
;;; Commentary:
;;
;; Configuration for Emacs
;;
;;; Code:

(defconst config-d "~/.config/emacs/")
(defconst lisp-d (expand-file-name "lisp/" user-emacs-directory))
(setq custom-file (expand-file-name "custom.el" config-d))

;; Set package archives and initialize
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(setq package-enable-at-startup nil)
(package-initialize)

;; Load lisp from here
(add-to-list 'load-path lisp-d)

;; Load some defuns
(require 'jd-defuns)

;; Precaution: Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Enable y/n answers
(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep things clean
(require-package 'no-littering)
(require 'no-littering)

;; Backups - better to be safe
(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Load hydra for some of the keybindings below
(require-package 'hydra)

;; Apropos commands on C-c a
(defhydra hydra-apropos (:color blue)
  "Apropos"
  ("a" apropos "apropos")
  ("c" apropos-command "cmd")
  ("d" apropos-documentation "doc")
  ("e" apropos-value "val")
  ("l" apropos-library "lib")
  ("u" apropos-user-option "option")
  ("o" apropos-user-option "option")
  ("v" apropos-variable "var")
  ("i" info-apropos "info")
  ("t" tags-apropos "tags")
  ("z" hydra-customize-apropos/body "customize"))

(defhydra hydra-customize-apropos (:color blue)
  "Apropos (customize)"
  ("a" customize-apropos "apropos")
  ("f" customize-apropos-faces "faces")
  ("g" customize-apropos-groups "groups")
  ("o" customize-apropos-options "options"))

(global-set-key (kbd "C-c a") #'hydra-apropos/body)

;; Text toggles and operations on C-c t
(defhydra hydra-toggle (:color blue)
  "Toggle"
  ("f" auto-fill-mode "fill")
  ("a" abbrev-mode "abbrev")
  ("l" linum-mode "linum")
  ("w" whitespace-mode "whitespace")
  ("t" toggle-truncate-lines "truncate")
  ("d" toggle-debug-on-error "debug"))

(global-set-key (kbd "C-c t") #'hydra-toggle/body)

;; Keybinding for unfill-paragraph
(global-set-key (kbd "M-Q") #'unfill-paragraph)

;; IBuffer
(require-package 'ibuffer-vc)
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              ;; (ibuffer-do-sort-by-alphabetic))))
              (ibuffer-do-sort-by-vc-status))))
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; Version-control
(require-package 'magit)
;; (global-set-key (kbd "C-c g") #'magit-status)

(require-package 'git-timemachine)
(global-set-key (kbd "C-x v t") #'git-timemachine)

;; Buffer map
(defhydra hydra-buffer (:color blue)
  "Buffer"
  ("a" align-regexp "align")
  ("b" create-scratch-buffer "scratch")
  ("c" compile "compile")
  ("e" eshell "eshell")
  ("g" magit-status "magit")
  ("m" bookmark-jump "bookmark")
  ("s" shell "shell")
  ("t" tidy-region-or-buffer "tidy"))

(global-set-key (kbd "C-c b") #'hydra-buffer/body)

;; Dired
(require 'jd-dired)
(require 'dired)

(autoload 'dired-jump "dired-x"
  "Jump to Dired buffer corresponding to current buffer." t)
(autoload 'dired-jump-other-window "dired-x"
  "Like \\[dired-jump] (dired-jump) but in other window." t)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(global-set-key (kbd "C-x C-j") #'dired-jump)
(global-set-key (kbd "C-x 4 C-j") #'dired-jump-other-window)

(define-key dired-mode-map (kbd "C-c C-s") 'sudired)
(define-key dired-mode-map "b" 'dired-open-file)
(define-key dired-mode-map "c" 'dired-open-fm)
(define-key dired-mode-map "e" 'ora-ediff-files)

(setq-default dired-clean-up-buffers-too t
              dired-recursive-copies 'always
              dired-recursive-deletes 'top)

;; Shell
(add-hook 'shell-mode-hook #'ansi-color-for-comint-mode-on)

;; Vkill
(autoload 'vkill "vkill" nil t)
(autoload 'list-unix-processes "vkill" nil t)

;; Ivy and Avy
(require-package 'diminish)
(require-package 'ivy)
(require-package 'counsel)

;; Ivy-related commands on C-c x
(defhydra hydra-counsel (:color blue)
  ("r" ivy-resume "resume")
  ("i" counsel-imenu "imenu")
  ("g" counsel-git "git")
  ("j" counsel-git-grep "grep")
  ("u" counsel-unicode-char "unicode")
  ("f" counsel-locate "find")
  ("a" counsel-ag "ag")
  ("l" counsel-info-lookup-symbol "symbol"))

(global-set-key (kbd "C-c x") #'hydra-counsel/body)

(ivy-mode 1)
(diminish 'ivy-mode)

(counsel-mode 1)
(diminish 'counsel-mode)

;; Go to swiper from isearch
(define-key isearch-mode-map (kbd "M-i") #'swiper-from-isearch)

(require-package 'avy)
(avy-setup-default)
(global-set-key (kbd "M-n") #'avy-goto-char-timer)
;; (global-set-key (kbd "M-j") #'avy-goto-char-timer)
(global-set-key (kbd "M-g t") #'avy-goto-char-timer)
(global-set-key (kbd "M-g c") #'avy-goto-char-2)
(global-set-key (kbd "M-g f") #'avy-goto-line)

(require-package 'tiny)
(global-set-key (kbd "C-;") 'tiny-expand)
;; (tiny-setup-default)

;; Text and Web
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

;; Links
(require-package 'ace-link)
(ace-link-setup-default)

;; Windows
(winner-mode 1)
(global-set-key (kbd "C-x p") (lambda () (interactive) (other-window -1)))

;; Macros
(global-set-key (kbd "C-c m") #'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "C-z") #'kmacro-end-or-call-macro)
(global-set-key (kbd "C-c C-z") #'save-kbd-macro)

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

;; Octave
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

;; C/C++
(require 'jd-cc)
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

(if (file-readable-p custom-file) (load-file custom-file))

;;; init.el ends here

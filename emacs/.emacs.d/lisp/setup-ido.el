(require 'flx-ido)
(require 'ido-ubiquitous)
(ido-mode 1)
(flx-ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(setq ido-enable-flex-matching t
      ido-use-faces nil
      ;; ido-use-virtual-buffers t
      ido-ignore-extensions t
      ido-use-filename-at-point 'guess
      ido-create-new-buffer 'prompt)

;; ;; smex
;; (autoload 'smex "smex"
;;   "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
;; your recently and most frequently used commands.")
;; (global-set-key (kbd "M-x") 'smex)

;; ;; ibuffer
;; (add-hook 'ibuffer-hook
;;           (lambda ()
;;             (ibuffer-vc-set-filter-groups-by-vc-root)
;;             (unless (eq ibuffer-sorting-mode 'alphabetic)
;;               (ibuffer-do-sort-by-alphabetic))))
;; (global-set-key (kbd "C-x C-b") 'ibuffer)

;; (add-to-list 'recentf-exclude "\\ido.last\\'")

(provide 'setup-ido)

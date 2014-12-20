;;; hide-modes.el --- Optionally hides modes in modeline

;;; Commentary:

;;; Code to hide major and minor modes.

;;; Code:

(defmacro diminish-minor-mode (filename mode &optional abbrev)
  `(eval-after-load (symbol-name ,filename)
     '(diminish ,mode ,abbrev)))

(defmacro diminish-major-mode (mode-hook abbrev)
  `(add-hook ,mode-hook
             (lambda () (setq mode-name ,abbrev))))

(diminish-major-mode 'emacs-lisp-mode-hook "El")
(diminish-major-mode 'lisp-interaction-mode-hook "Λ")
(diminish-major-mode 'python-mode-hook "Py")
(diminish-major-mode 'dired-mode-hook "Δ")

(diminish-minor-mode 'auto-complete 'auto-complete-mode " α")
(diminish-minor-mode 'eldoc 'eldoc-mode)
(diminish-minor-mode 'flycheck 'flycheck-mode)
(diminish-minor-mode 'flyspell 'flyspell-mode)
(diminish-minor-mode 'golden-ratio 'golden-ratio-mode)
(diminish-minor-mode 'global-whitespace 'global-whitespace-mode)
(diminish-minor-mode 'magit 'magit-auto-revert-mode)
(diminish-minor-mode 'projectile 'projectile-mode " π")
(diminish-minor-mode 'smartparens 'smartparens-mode)
(diminish-minor-mode 'subword 'subword-mode " σ")
(diminish-minor-mode 'whitespace 'whitespace-mode)
(diminish-minor-mode 'wrap-region 'wrap-region-mode)


(provide 'hide-modes)

;;; hide-modes.el ends here

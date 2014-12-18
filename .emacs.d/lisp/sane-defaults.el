;;; sane-defaults.el --- Saner defaults for emacs

;;; Commentary:

;;; Defaults that should probably be set by everyone.

;;; Sources:
;;; - https://github.com/magnars/.emacs.d/blob/master/sane-defaults.el

;;; Code:

;; Quiet startup
(setq inhibit-startup-message t)

;; Don't show message in the scratch buffer
(setq initial-scratch-message nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;; Remove text in active region if inserting text
(delete-selection-mode 1)

;; Move files to trash when deleting
(setq delete-by-moving-to-trash t)

;; Show keystrokes in progress
(setq echo-keystrokes 0.1)

;; Lines should be 80 characters wide, not 72
(setq fill-column 80)

;; Never insert tabs
(set-default 'indent-tabs-mode nil)

;; Show me empty lines after buffer end
(set-default 'indicate-empty-lines t)

;; Sentences do not need double spaces to end. Period.
(set-default 'sentence-end-double-space nil)

;; Keep popping mark on repeated C-<SPC>
(setq set-mark-command-repeat-pop t)

;; Show column number in mode line
(column-number-mode 1)

;; Show matching parens
(show-paren-mode t)

;; Modern memory threshold
(setq gc-cons-threshold 20000000)

(provide 'sane-defaults)

;;; sane-defaults.el ends here

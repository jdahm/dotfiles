;;; setup-package.el --- Sets up package archive and defins packages-install

;;; Commentary:

;;; Source: https://github.com/magnars/.emacs.d/

;;; Code:

(require 'package)

;; Add melpa to package repos
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defun packages-install (pkgs)
    (dolist (p pkgs)
      (when (not (package-installed-p p))
        (package-install p))))

(provide 'setup-package)

;;; setup-package.el ends here

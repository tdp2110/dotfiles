(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq recenter-positions '(middle top bottom))

(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 
   'package-archives 
   '("melpa" . "http://melpa.org/packages/") 
   t)
  (package-initialize))




(global-set-key (kbd "C-x f") 'fiplr-find-file)

(setq fiplr-ignored-globs '((directories (".git" ".build"))
                            (files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc" "nosetests.*.xml"))))


(setq auto-mode-alist (cons '("\\.pyx$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ypp$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hppml$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cppml$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cu$" . cuda-mode) auto-mode-alist))
(setq-default c-default-style "whitesmith"
		c-basic-offset 4
		tab-width 4
		indent-tabs-mode nil)
(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(require 'coffee-mode)
(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

;;(add-to-list 'load-path "~/.emacs.d/vendor/markdown-mode")
;;(require 'markdown-mode)
;;(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)) 

(setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace

(add-to-list 'auto-mode-alist '("\\.fora\\'" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)

(setq confirm-kill-emacs 'yes-or-no-p)
;;(add-to-list 'load-path' "/home/tom/ess/lisp/")
;;(load "ess-site")

(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
        (end (line-end-position arg)))
    (when mark-active
      (if (> (point) (mark))
          (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
        (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
    (if (eq last-command 'copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

(global-set-key "\C-c\C-k" 'copy-line)

;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/magit")
;;(require 'magit)

;;(require 'ess-site)

;;(add-to-list 'load-path "/home/tom/neotree")
;;(require 'neotree)
;;(global-set-key [f8] 'neotree-toggle)

;; Configure flymake for Python
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

;; Set as a minor mode for Python
(add-hook 'python-mode-hook '(lambda () (flymake-mode)))

;; Configure to wait a bit longer after edits before starting
(setq-default flymake-no-changes-timeout '3)

;; Keymaps to navigate to the errors
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cn" 'flymake-goto-next-error)))
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cp" 'flymake-goto-prev-error)))

;; To avoid having to mouse hover for the error message, these functions make flymake error messages
;; appear in the minibuffer
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the message in the minibuffer"
  (require 'cl)
  (interactive)
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
      (let ((err (car (second elem))))
        (message "%s" (flymake-ler-text err)))))))

(add-hook 'post-command-hook 'show-fly-err-at-point)
(setq py-python-command "python3")

(setq load-path
      (cons (expand-file-name "/Users/tpeters/projects/llvm/utils/emacs") load-path))
(require 'llvm-mode)

(setq pyflakes "/usr/local/bin/pyflakes")

(setq-default indent-tabs-mode nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (clang-format tuareg swift-mode objc-font-lock yaml-mode csharp-mode dockerfile-mode opencl-mode cuda-mode flymake-python-pyflakes protobuf-mode fiplr magit cmake-mode neotree markdown-mode coffee-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)


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

(setq fiplr-ignored-globs '((directories (".git" "build" "ThirdParty/build" "build.samples" "pkg" ".tox" "digits/digits/jobs/"))
                            (files ("*.jpg" "*.png" "*.zip" "*~" "*.pyc" "nosetests.*.xml"))))


(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.metal$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.m$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mm$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.prototxt$" . protobuf-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pyx$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ypp$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.hppml$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cppml$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Dockerfile\\." . dockerfile-mode) auto-mode-alist))
(setq-default c-default-style "linux"
              c-basic-offset 4
              tab-width 4
              indent-tabs-mode nil)
(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

(add-to-list 'load-path "~/.emacs.d/vendor/markdown-mode")
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

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

(add-to-list 'load-path "/home/tom/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(setq column-number-mode t)


(require 'opencl-mode)
(add-to-list 'auto-mode-alist '("\\.cl\\'" . opencl-mode))
(add-hook 'before-save-hook 'whitespace-cleanup)

(add-hook 'after-init-hook #'global-flycheck-mode)

;; Set as a minor mode for Python
(add-hook 'python-mode-hook '(lambda () (flymake-mode)))

;; Configure to wait a bit longer after edits before starting
(setq-default flymake-no-changes-timeout '3)

;; Keymaps to navigate to the errors
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cn" 'flymake-goto-next-error)))
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cp" 'flymake-goto-prev-error)))


(load "/home/tom/clang-format.el")
(global-set-key [C-M-tab] 'clang-format-region)
(global-set-key [C-M-c] 'clang-format-region)


(defun my-c++-mode-before-save-hook ()
  (when (eq major-mode 'c++-mode)
    ('clang-format-buffer 'local)))


(defun clang-format-buffer-wrapper ()
  ('clang-format-buffer nil 'buffer-file-name))

(add-hook 'c++-mode-hook (lambda () (add-hook 'before-save-hook 'clang-format-buffer 'make-it-local 'make-it-local)))

(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

(require 'flycheck)

;; We can safely declare this function, since we'll only call it in Python Mode,
;; that is, when python.el was already loaded.
(declare-function python-shell-calculate-exec-path "python")

(defun flycheck-virtualenv-executable-find (executable)
  "Find an EXECUTABLE in the current virtualenv if any."
  (if (bound-and-true-p python-shell-virtualenv-root)
      (let ((exec-path (python-shell-calculate-exec-path)))
        (executable-find executable))
    (executable-find executable)))

(defun flycheck-virtualenv-setup ()
  "Setup Flycheck for the current virtualenv."
  (setq-local flycheck-executable-find #'flycheck-virtualenv-executable-find))

(provide 'flycheck-virtualenv)

(add-hook 'python-mode-hook #'flycheck-virtualenv-setup)

(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))

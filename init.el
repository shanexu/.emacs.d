(message "hello world")

(setq straight-use-package-by-default t)
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(setq inhibit-startup-message t)

(use-package standard-themes)

(use-package kaolin-themes
  :config
  (load-theme 'kaolin-dark t))

(defun load-dark-theme ()
  (load-theme 'kaolin-dark t))

(defun load-light-theme ()
  (load-theme 'kaolin-light t))

(use-package auto-dark
  :straight (auto-dark :type git :host github :repo "shanexu/auto-dark-emacs")
  :config
  (setq auto-dark-dark-mode-hook 'load-dark-theme)
  (setq auto-dark-light-mode-hook 'load-light-theme)
  (auto-dark-mode t))

(use-package spaceline
  :config
  (require 'spaceline-config)
  (spaceline-emacs-theme))

(use-package winum
  :init
  (setq winum-auto-setup-mode-line nil)
  :config
  (winum-mode))

(use-package cnfonts
  :config
  (cnfonts-mode 1))

(use-package org
  :hook
  (org-mode . org-indent-mode))

(use-package org-superstar
  :hook
  (org-mode . org-superstar-mode))

(use-package vertico
  :straight (vertico :type git :host github :repo "minad/vertico" :files ("*.el" "extensions/*.el"))
  :init
  (vertico-mode)
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)
  :config
  (setq vertico-resize nil
        vertico-count 17
        vertico-cycle t)
  (setq-default completion-in-region-function
                (lambda (&rest args)
                  (apply (if vertico-mode
                             #'consult-completion-in-region
                           #'completion--in-region)
                         args)))
  :bind (:map vertico-map ("DEL" . vertico-directory-delete-char))
  :hook
  (minibuffer-setup . vertico-repeat-save)
  (rfn-eshadow-update-overlay . vertico-directory-tidy)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package smartparens
  :config
  (require 'smartparens-config))

(use-package vterm
  :ensure t)

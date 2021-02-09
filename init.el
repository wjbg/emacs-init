
;; Package sources
(package-initialize)
(require 'package)
(setq package-archives '(("gnu" . "http://mirrors.163.com/elpa/gnu/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")))

;; Install use-package if needed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package)))

;; Packages are installed by default (e.g. ensure: t)
(setq use-package-always-ensure t)

;; Find configuration file
(defun find-config ()
  "Edit init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "C-c I") 'find-config)

;; Prevent emacs from poluting the init file with customizations
(setq custom-file (make-temp-file "emacs-custom"))


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Look and Feel
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Turn of tool, menu and scroll bar, start full screen
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(add-hook 'emacs-startup-hook 'toggle-frame-maximized)

;; Lines need to wrap
(global-visual-line-mode 1)

;; Here, sentences end with a . and a single space.
(setq sentence-end-double-space nil)

;; Theme
(use-package material-theme
  :config
  (load-theme 'material t))

;; Set a decent font
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono-11"))
(setq org-fontify-whole-heading-line t)

;; Hightlight current line
(global-hl-line-mode 1)

;; In God's name, what am I doing?
(setq frame-title "Hey sunshine, you are working on a file called ")
(setq-default frame-title-format (concat frame-title "%b" ". Keep going!"))

;; Where is my cursor at?
(use-package beacon
  :bind ("C-c b" . beacon-blink)
  :config (beacon-mode 1))

;; I like shiny things
(use-package all-the-icons
  :init
  (setq inhibit-compacting-font-caches t)
  )

;; Smooth operator.
(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")

;; Find word fast
(use-package avy
  :ensure t
  :bind ("C-." . avy-goto-char)
  )

;; Undo in way I understand
(use-package undo-tree
  :defer 5
  :config
  (global-undo-tree-mode 1))

(use-package ace-window
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
              aw-char-position 'left
              aw-ignore-current nil
              aw-leading-char-style 'char
              aw-scope 'frame)
  :bind (("M-o" . ace-window)
         ("M-O" . ace-swap-window)))

;; Dashboard
(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official)
  (setq dashboard-items '((recents  . 15)
                          (bookmarks . 5)))
  (setq dashboard-center-content t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-init-info t)
  :config
  (dashboard-setup-startup-hook))

;; Selectrum is an incremental narrowing solution
(use-package selectrum
  :init
  (selectrum-mode))

;; Prescient enables saving history, and selectrum-prescient
;; (obviously) integrates the two.
(use-package prescient
  :config
  (prescient-persist-mode)
  (setq prescient-history-length 1000))

(use-package selectrum-prescient
  :demand t
  :after selectrum
  :config
  (selectrum-prescient-mode))

;; Powerline
(use-package powerline
  :init
  (powerline-default-theme)
  )

;; Boon modal editing
(use-package boon
  :init
  ;; (boon-mode)
  )


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; File system tools
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Set some proper defaults
(setq dired-dwim-target t) ;; allows copy to other buffer
(setq ls-lisp-dirs-first t)
(setq ls-lisp-verbosity nil)
(setq ls-lisp-use-insert-directory-program nil)
(setq ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M"))
(setq ls-lisp-use-localized-time-format t)

;; Fancy icons
(use-package all-the-icons-dired
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; Some handy commands.
(defun dired-sumatraPDF () (interactive)
       (setq fn (dired-get-filename))
       (let ((proc (start-process "cmd" nil "C:/Program Files/SumatraPDF/sumatraPDF.exe" fn)))
	 (set-process-query-on-exit-flag proc nil)))

(add-hook 'dired-mode-hook
          (lambda () (local-set-key (kbd "C-c p") 'dired-sumatraPDF)))

(defun start-cmd () (interactive)
       (let ((proc (start-process "cmd" nil "cmd.exe" "/C" "start" "cmd.exe")))
	 (set-process-query-on-exit-flag proc nil)))

(use-package magit
  :bind (("C-x g" . magit-status)))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Writing stuff
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Splelling is hard. Let's get some hlep.
(use-package ispell
  :defer t
  :init(progn
  	 (add-to-list 'exec-path "c:/Program Files (x86)/Hunspell/bin/")
	 (setq ispell-program-name "hunspell")
	 (setq ispell-dictionary "en_US")
	 (setq ispell-local-dictionary-alist
	       '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))))

;; And closing brackets (or parentheses is also difficult.
(use-package autopair
  :config (autopair-global-mode))

;; LaTeX rules!
(use-package tex
  :ensure auctex)

;; Remove white space at the end of lines before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Highligh poor prose
(use-package writegood-mode
  :bind ("C-c g" . writegood-mode)
  :config
  (add-to-list 'writegood-weasel-words "actionable"))

;; Find word definition
(use-package define-word
  :bind (("C-c w" . define-word-at-point)
	 ("C-c W" . define-word)
	 )
  )

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Org mode
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package org
  :mode("\\.org" . org-mode)
  :defer t
  :config(progn
	   (global-font-lock-mode 1)
	   (setq org-image-actual-width 300) ;; images inline
	   (setq org-hide-leading-stars t)) ;; hide stars

           ;; make latex work properly
           (setq org-latex-pdf-process '("latexmk -bibtex -pdf -f %f"))
           (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
	   (setq org-export-allow-bind-keywords t)
	   (setq org-latex-listings 'minted)
  )

(use-package org-bullets
  :init
  (add-hook 'org-mode-hook (lambda ()
                             (org-bullets-mode 1)))
  )

(require 'ox-beamer)
(require 'ox-latex)

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Elfeed
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package elfeed
  :bind ("C-x w" . elfeed)
  :config
  (setq elfeed-feeds
	'(("http://rss.sciencedirect.com/publication/science/1359835X" Comp.A)
	  ("http://rss.sciencedirect.com/publication/science/02663538" Comp.Sci.Tech.)
	  ("http://rss.sciencedirect.com/publication/science/13598368" Comp.B)
	  ("https://journals.sagepub.com/action/showFeed?ui=0&mi=ehikzz&ai=2b4&jc=jtca&type=etoc&feed=rss" JTCM)
	  ))
  )


(use-package elfeed-goodies
  :config
  (elfeed-goodies/setup)
  )


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Ebib
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package ebib
  :config
  (setq ebib-preload-bib-files (quote ("C:\\Users\\grouvewjb\\Documents\\Literature\\references.bib")))
  )


;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Deft
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
(use-package deft
  :bind ("C-c d" . deft)
  :config (setq deft-directory "c:/Users/grouvewjb/Documents/Work/notes")
	  (setq deft-extensions '("org"))
	  (setq deft-default-extension "org")
	  (setq deft-text-mode 'org-mode)
	  (setq deft-use-filename-as-title t)
	  (setq deft-use-filter-string-for-filename t)
	  (setq deft-auto-save-interval 0)

	  ;; advise deft-new-file-named to replace spaces in file names with -
	  (defun bjm-deft-strip-spaces (args)
	    (list (replace-regexp-in-string " " "-" (car args))))
	  (advice-add 'deft-new-file-named :filter-args #'bjm-deft-strip-spaces)
  )

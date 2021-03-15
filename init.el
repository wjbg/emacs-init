;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Emacs Init File
;; Author: Wouter Grouve, University of Twente
;; License: MIT
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;;
;; Generic settings
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

;; Directories
(setq home-dir (concat (getenv "USERPROFILE") "\\"))
(setq work-dir (concat (getenv "USERPROFILE") "\\Documents\\Work\\"))
(setq literature-dir (concat (getenv "USERPROFILE") "\\Documents\\Literature\\"))
(setq program-files (concat (getenv "ProgramFiles") "\\"))
(setq program-files-x86 (concat (getenv "ProgramFiles(x86)") "\\"))

;; Find configuration file
(defun find-config ()
  "Edit init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c I") 'find-config)

;; Find passwords file
(defun find-passwords ()
  "Edit init.el"
  (interactive)
  (find-file (concat work-dir "private/passwords.org.gpg")))
(global-set-key (kbd "C-c P") 'find-passwords)

;; Prevent emacs from poluting the init file with customizations
(setq custom-file (make-temp-file "emacs-custom"))


;;
;; Look and Feel
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; UTF-8 as the default encoding
(set-language-environment "UTF-8")

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

;; Something for the eye
(use-package material-theme
  :config
  (load-theme 'material t))

;; And something additional for the eye
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono-11"))
(setq org-fontify-whole-heading-line t)

;; Hightlight current line
(global-hl-line-mode 1)

;; In God's name, what am I doing?
(setq frame-title "Hey sunshine, you are working on a file called ")
(setq-default frame-title-format (concat frame-title "%b" ". Keep going!"))

;; Remove some of the modeline clutter
(use-package diminish
  :diminish abbrev-mode
  :diminish auto-revert-mode
  :diminish subword-mode
  :diminish visual-line-mode
  :diminish eldoc-mode
  :diminish auto-fill-function
  :diminish org-indent-mode
  :diminish all-the-icons-dired-mode
  :diminish which-key-mode)

;; Don't ring the annoying bell, but do notify me dear
(use-package mode-line-bell
  :config (mode-line-bell-mode))

;; Where is my cursor at?
(use-package beacon
  :defer 2
  :bind ("C-c b" . beacon-blink)
  :config (beacon-mode 1))

;; I like shiny things
(use-package all-the-icons
  :init (setq inhibit-compacting-font-caches t))

;; Smooth operator
(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")

;; Find word fast
(use-package avy
  :defer 10
  :ensure t
  :bind ("C-." . avy-goto-char))

;; Undo in way I understand
(use-package undo-tree
  :diminish undo-tree-mode
  :defer 10
  :config
  (global-undo-tree-mode 1))

;; Swap windows in a predictable manner
(use-package ace-window
  :defer t
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
              aw-char-position 'left
              aw-ignore-current nil
              aw-leading-char-style 'char
              aw-scope 'frame)
  :bind (("M-o" . ace-window)
         ("M-O" . ace-swap-window)))

;; Which key should I press now?
(use-package which-key
  :defer 10
  :config
  (which-key-mode)
  )

;; Dashboard
(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official)
  (setq dashboard-items '((recents  . 10)
                          (bookmarks . 5)
	                  (projects . 2)))
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-set-init-info t)
  :config
  (dashboard-setup-startup-hook))

;; Selectrum is a lean incremental narrowing framework
(use-package selectrum
  :init
  (selectrum-mode))

;; Prescient enables saving history
(use-package prescient
  :after selectrum
  :config
    (selectrum-prescient-mode +1)
    (prescient-persist-mode +1))

;; Consult helps finding stuff
(use-package consult
  :ensure t
  :bind (("C-c o" . consult-outline)
         ("C-x b" . consult-buffer)
         ("C-x r x" . consult-register)
         ("C-x r b" . consult-bookmark)
         ("M-g o" . consult-ouline)
         ("M-y" . consult-yank-pop))
  :init
  (fset 'multi-occur #'consult-multi-occur))

;; Helpful information in the mini-buffer
(use-package marginalia
  :init
  (marginalia-mode)
  (setq marginalia-annotators
        '(marginalia-annotators-heavy marginalia-annotators-light)))

;; Better help
(use-package helpful
  :defer 30
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)

  ;; Lookup the current symbol at point
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)

  ;; Look up *F*unctions (excludes macros)
  (global-set-key (kbd "C-h F") #'helpful-function)

  ;; Look up *C*ommands.
  (global-set-key (kbd "C-h C") #'helpful-command)
  )

;; Powerline. Just because it looks better.
(use-package powerline
  :init
  (powerline-default-theme))

;; Helpful stuff from crux
(use-package crux
  :config
  (global-set-key (kbd "C-k") #'crux-smart-kill-line)
  (global-set-key (kbd "C-a") #'crux-move-beginning-of-line)
  (global-set-key (kbd "S-<RET>") #'crux-smart-open-line)
  (global-set-key (kbd "C-S-<RET>") #'crux-smart-open-line-above)
  (global-set-key (kbd "C-^") #'crux-top-join-line))

;; This is useful as well
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; Feel like a God, act like a God!
(use-package god-mode
  :config
  (global-set-key (kbd "<escape>") #'god-local-mode)
  (define-key god-local-mode-map (kbd ".") #'repeat)
  (define-key god-local-mode-map (kbd "i") #'god-local-mode)

  ;; Change cursor to indicate
  (defun my-god-mode-update-cursor ()
    (if (or god-local-mode buffer-read-only)
       (set-cursor-color "lime green")
      (set-cursor-color "dark orange")))

  (add-hook 'god-mode-enabled-hook #'my-god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my-god-mode-update-cursor)
  (god-mode)
  )


;;
;; File system tools
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Set some proper defaults
(setq dired-dwim-target t) ;; allows copy to other buffer
(setq ls-lisp-dirs-first t)
(setq ls-lisp-verbosity nil)
(setq ls-lisp-use-insert-directory-program nil)
(setq ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M"))
(setq ls-lisp-use-localized-time-format t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Use native ls
(setq ls-lisp-use-insert-directory-program t)
(setq insert-directory-program (concat program-files "Git\\usr\\bin\\ls.exe"))

;; Quick sort
(use-package dired-quick-sort
  :ensure t
  :config
  (dired-quick-sort-setup))

;; Fancy icons because I like shiny stuff
(use-package all-the-icons-dired
  :defer t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; Some handy commands
(defun dired-sumatraPDF () (interactive)
       (setq fn (dired-get-filename))
       (setq sumatra (concat program-files "SumatraPDF\\sumatraPDF.exe"))
       (let ((proc (start-process "cmd" nil sumatra fn)))
	 (set-process-query-on-exit-flag proc nil)))

(add-hook 'dired-mode-hook
          (lambda () (local-set-key (kbd "C-c p") 'dired-sumatraPDF)))

(defun start-cmd () (interactive)
       (let ((proc (start-process "cmd" nil "cmd.exe" "/C" "start" "cmd.exe")))
	 (set-process-query-on-exit-flag proc nil)))

;; In case I fuck up and ruin my hard work
(use-package magit
  :defer t
  :init (setenv "GIT_ASKPASS" "git-gui--askpass")
  :bind (("C-x g" . magit-status)))


;;
;; Writing stuff
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Splelling is hard. Let's get some hlep.
(use-package ispell
  :defer t
  :init(progn
  	 (add-to-list 'exec-path (concat program-files-x86 "Hunspell\\bin\\") )
	 (setq ispell-program-name "hunspell")
	 (setq ispell-dictionary "en_US")
	 (setq ispell-local-dictionary-alist
	       '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))))

;; And closing brackets (or parentheses is also difficult.
(use-package autopair
  :defer 5
  :diminish autopair-mode
  :config (autopair-global-mode))

;; Fast, faster, fastest!
(add-hook 'org-mode-hook (lambda () (abbrev-mode 1)))
(setq abbrev-file-name "~/.emacs.d/.abbrev_defs")

;; Unfill mode
(use-package unfill
  :defer 10)

;; LaTeX rules!
(use-package tex
  :defer t
  :ensure auctex)

;; Remove white space at the end of lines before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Highligh poor prose
(use-package writegood-mode
  :defer t
  :bind ("C-c g" . writegood-mode)
  :config
  (add-to-list 'writegood-weasel-words "actionable"))

;; Find word definition
(use-package define-word
  :defer t
  :bind (("C-c w" . define-word-at-point)
	 ("C-c W" . define-word)))

;; Markdown mode
(use-package markdown-mode
  :defer t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Create a scratch buffer in the same mode as I am working in
(use-package scratch)

;; I don't like typing stuff over and over again...
(use-package yasnippet
  :defer 5
  :diminish yas-minor-mode
  :config (yas-global-mode))

(use-package yasnippet-snippets
  :after yasnippet)


;;
;; Org mode
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Let's get organized... Though mostly used for writing
(use-package org
  :mode("\\.org" . org-mode)
  :defer t
  :config(progn
	   (global-font-lock-mode 1)
	   (setq org-image-actual-width 300) ;; images inline
	   (setq org-hide-leading-stars t)) ;; hide stars

           ;; make LaTex work properly
           (setq org-latex-pdf-process '("latexmk -bibtex -pdf -f %f"))
           (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
	   (setq org-export-allow-bind-keywords t)
	   (setq org-latex-listings 'minted)

	   (setq org-preview-latex-default-process 'dvipng)
	   (setq org-preview-latex-process-alist
		 '(
		   (dvipng
		    :programs ("latex" "dvipng")
		    :description "dvi > png"
		    :message "you need to install the programs: latex and dvipng."
		    :image-input-type "dvi"
		    :image-output-type "png"
		    :image-size-adjust (1.0 . 1.0)
		    :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
		    :image-converter ("dvipng -D %D -T tight -o %O %f")
		    )
		   )
		 )

	   ;; Source blocks for my executable papers
	   (setq org-confirm-babel-evaluate nil)
	   (setq org-src-fontify-natively t)

	   ;; Prevent abbrev-mode from expanding my variables in code blocks
	   (setq abbrev-expand-function (lambda ()
					  (unless (org-in-src-block-p)
					    (abbrev--default-expand))))
	   ;; Org babel languages
	   (org-babel-do-load-languages
	    'org-babel-load-languages
	    '((python . t)
	      (latex . t)
	      (jupyter . t))))

;; Pretty bullets, I like shiny things...
(use-package org-bullets
  :defer t
  :init
  (add-hook 'org-mode-hook (lambda ()
                             (org-bullets-mode 1))))

(require 'ox-beamer)
(require 'ox-latex)


;;
;; Elfeed
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Stay informed
(use-package elfeed
  :defer t
  :bind ("C-c e" . elfeed)
  :config
  (setq elfeed-feeds
	'(("http://rss.sciencedirect.com/publication/science/1359835X" Comp.A)
	  ("http://rss.sciencedirect.com/publication/science/02663538" Comp.Sci.Tech.)
	  ("http://rss.sciencedirect.com/publication/science/13598368" Comp.B)
	  ("https://journals.sagepub.com/action/showFeed?ui=0&mi=ehikzz&ai=2b4&jc=jtca&type=etoc&feed=rss" JTCM)
	  )))

(use-package elfeed-goodies
  :after elfeed
  :config
  (elfeed-goodies/setup))


;;
;; Ebib
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Reference management
(use-package ebib
  :defer t
  :config
  (setq ebib-preload-bib-files (quote ((concat literature-dir "references.bib")))))


;;
;; Deft
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Store stuff in a way I can actually recover it...
(use-package deft
  :defer t
  :bind ("C-c d" . deft)
  :config (setq deft-directory (concat work-dir "notes"))
	  (setq deft-extensions '("org"))
	  (setq deft-default-extension "org")
	  (setq deft-text-mode 'org-mode)
	  (setq deft-use-filename-as-title t)
	  (setq deft-use-filter-string-for-filename t)
	  (setq deft-auto-save-interval 0)

	  ;; advise deft-new-file-named to replace spaces in file names with -
	  (defun bjm-deft-strip-spaces (args)
	    (list (replace-regexp-in-string " " "-" (car args))))
	  (advice-add 'deft-new-file-named :filter-args #'bjm-deft-strip-spaces))


;;
;; Projectile and dumb-jump
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

(use-package projectile
  :defer t
  :diminish projectile-mode
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c o" . projectile-command-map)))

(use-package dumb-jump
  :defer t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))


;;
;; Python
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Python editing environment
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt"
      python-shell-prompt-detect-failure-warning nil)
  (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter"))

(use-package jupyter
  :defer t
  :init
  (setq org-babel-default-header-args:jupyter-python '((:async . "no")
                                                       (:session . "py")))
  :commands (jupyter-run-server-repl
             jupyter-run-repl
             jupyter-server-list-kernels))

;; Anaconda environment management
(use-package conda
  :init
  (setq conda-env-home-directory (expand-file-name (concat home-dir "Anaconda3")))
  :config
  (custom-set-variables '(conda-anaconda-home (concat home-dir "Anaconda3")))
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t))

(defun activate-python3 ()
  "Activate python 3 environment and initialize ob-jupyter."
  (interactive)
  (conda-env-activate "python3")
  (jupyter-available-kernelspecs 'refresh)
  (conda-env-initialize-eshell)
  (org-babel-jupyter-aliases-from-kernelspecs))


;;
;; Matlab
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Sometimes I need to edit Matlab files, why not use a proper editor
(use-package matlab
  :defer t
  :ensure matlab-mode
  :config
  (add-to-list
   'auto-mode-alist
   '("\\.m\\'" . matlab-mode))
  (setq matlab-indent-function t)
  (setq matlab-shell-command "matlab"))

;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;
;; Emacs Init File
;; Author: Wouter Grouve, University of Twente
;; License: MIT
;;
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;;
;; Generic settings
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Package sources
(package-initialize)
(require 'package)
(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; Install use-package if needed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package)))

;; Packages are installed by default (e.g. ensure: t)
(setq use-package-always-ensure t)

;; Directories
(setq home-dir (concat (getenv "USERPROFILE") "\\OneDrive - University of Twente\\")
      work-dir (concat home-dir "Documents\\Work\\")
      choco-dir "C:\\ProgramData\\chocolatey\\bin\\"
      literature-dir (concat home-dir "Documents\\Literature\\")
      program-files (concat (getenv "ProgramFiles") "\\")
      program-files-x86 (concat (getenv "ProgramFiles(x86)") "\\"))

;; Load personal functions
(load-file "~/.emacs.d/wg-functions.el")

;; Find configuration file
(defun wg/find-config ()
  "Edit init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c I") 'wg/find-config)

;; Find passwords file
(custom-set-variables '(epg-gpg-program  (concat program-files-x86 "gnupg\\bin\\gpg.exe")))
(defun wg/find-passwords ()
  "Open password file.el"
  (interactive)
  (find-file (concat work-dir "private/passwords.org.gpg")))
(global-set-key (kbd "C-c P") 'wg/find-passwords)

;; Prevent emacs from poluting the init file with customizations
(setq custom-file (make-temp-file "emacs-custom"))

;; Get rid of some annoyances
(setq enable-recursive-minibuffers  t)
(minibuffer-depth-indicate-mode 1)


;;
;; Look and Feel
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; UTF-8 as the default encoding
(set-language-environment "UTF-8")

;; Turn of tool, menu and scroll bar, start full screen
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)
(add-hook 'emacs-startup-hook 'toggle-frame-maximized)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist `(alpha . ,'(90 . 90)))

;; Line numbering
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Make sure I don't minimize when accidentally trying to undo wrongly...
(global-unset-key (kbd "C-z"))

;; Lines need to wrap
(global-visual-line-mode 1)

;; Here, sentences end with a . and a single space.
(setq sentence-end-double-space nil)

;; Something for the eye - Theme
(use-package emacs
  :init
  (setq modus-themes-bold-constructs t
	modus-themes-italic-constructs t
	modus-themes-mixed-fonts t
	modus-themes-tabs-accented t
	modus-themes-mode-line '(moody borderless accented)
	modus-themes-hl-line '(accented intense)
	modus-themes-markup '(bold intense)
	modus-themes-region '(bg-only no-extend)
	modus-themes-syntax '(alt-syntax green-strings yellow-comments)
	modus-themes-headings '((1 . (rainbow overline variable-pitch 9.5))
				(2 . (rainbow overline 1.3))
				(3 . (rainbow overline 1.1))
				(t . (monochrome)))
	modus-themes-completions '((matches . (extrabold background intense))
				   (selection . (semibold accented intense))
				   (popup . (accented))))
  :config
  (load-theme 'modus-vivendi)
  :bind ("<f5>" . modus-themes-toggle))

;; And something additional for the eye - Fonts
(set-face-attribute 'default nil :font "Hack-11")
(set-face-attribute 'fixed-pitch nil :font "Hack-11")
(set-face-attribute 'variable-pitch nil :font "Cantarell-12")

;; Hightlight current line
(global-hl-line-mode t)

;; In God's name, what am I doing? - Frame Title
(setq frame-title "Hey sunshine, you are working on a file called ")
(setq-default frame-title-format (concat frame-title "%b" ". Keep going!"))

;; Don't ring the annoying bell, but do notify me.
(use-package mode-line-bell
  :defer t
  :config (mode-line-bell-mode))

;; I like shiny things
(use-package all-the-icons
  :diminish all-the-icons-dired-mode
  :init (setq inhibit-compacting-font-caches t))

;; Act like a God
(use-package god-mode
  :bind (("<escape>" . god-local-mode)
         ("C-x C-1" . delete-other-windows)
         ("C-x C-2" . split-window-below)
         ("C-x C-3" . split-window-right)
         ("C-x C-0" . delete-window)
	 :map god-local-mode-map
	 ("i" . god-local-mode)
	 ("." . repeat)
	 ("[" . backward-paragraph)
	 ("]" . forward-paragraph)))

(defun my-update-cursor ()
  (setq cursor-type (if (or god-local-mode buffer-read-only) 'box 'bar)))

(add-hook 'god-mode-enabled-hook 'my-update-cursor)
(add-hook 'god-mode-disabled-hook 'my-update-cursor)

;; Undo in way I understand
(use-package undo-tree
  :diminish undo-tree-mode
  :defer t
  :config
  (global-undo-tree-mode 1))

;; Swap windows in a predictable manner and enable winner-mode
(use-package ace-window
  :defer t
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)
        aw-char-position 'left
        aw-ignore-current nil
        aw-leading-char-style 'char
        aw-scope 'frame)
  (winner-mode 1)
  :bind (("M-o" . ace-window)
	 ("<f1>" . previous-buffer)
	 ("<f2>" . next-buffer)))

;; Remove some of the modeline clutter
(use-package diminish
  :diminish abbrev-mode
  :diminish auto-revert-mode
  :diminish subword-mode
  :diminish visual-line-mode
  :diminish eldoc-mode
  :diminish auto-fill-function
  :diminish org-indent-mode
  :diminish all-the-icons-dired-mode)

;; Dashboard
(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official
	dashboard-items '((recents  . 15)
                          (bookmarks . 10))
	dashboard-center-content t
	dashboard-set-heading-icons t
	dashboard-set-navigator t
	dashboard-set-init-info t)
  :config
  (dashboard-setup-startup-hook))

;; Completion bufffer
(use-package vertico
  :init
  (vertico-mode))

;; Offers orderless completion style, which is quite convenient
(use-package orderless
  :init
  (setq completion-styles '(orderless)))

;; Keep track of history, even if Emacs restarts
(use-package savehist
  :init
  (savehist-mode))

;; Helpful information in the mini-buffer
(use-package marginalia
  :init (marginalia-mode)
  (setq marginalia-annotators
        '(marginalia-annotators-heavy marginalia-annotators-light)))

(use-package all-the-icons-completion
  :init (all-the-icons-completion-marginalia-setup))

;; Corfu for inline completion
(use-package corfu
  :config
  (setq corfu-auto t)
  (setq tab-always-indent 'complete)
  (setq completion-cycle-threshold nil)
  (global-corfu-mode))

;; Help with keys
(use-package which-key
  :defer t
  :config
  (which-key-mode))

;; Better modeline
(use-package mood-line
  :init (mood-line-mode))

;; Better help
(use-package helpful
  :defer t
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key))


;;
;; File system tools
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Set some proper defaults
(setq dired-dwim-target t ;; allows copy to other buffer
      ls-lisp-dirs-first t
      ls-lisp-verbosity nil
      ls-lisp-use-insert-directory-program t
      insert-directory-program (concat program-files "Git\\usr\\bin\\ls.exe")
      ls-lisp-format-time-list '("%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M")
      ls-lisp-use-localized-time-format t
      delete-by-moving-to-trash t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(add-hook 'dired-mode-hook (lambda () (diminish 'all-the-icons-dired-mode)))

;; Help me sort stuff
(use-package dired-quick-sort
  :defer 30
  :config
  (dired-quick-sort-setup))

;; Fancy icons because I like shiny stuff
(use-package all-the-icons-dired
  :defer t
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; In case I fuck up and ruin my hard work
(use-package magit
  :defer t
  :bind (("C-x g" . magit-status)))


;;
;; Editing and writing
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Smooth operator
(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")
(global-set-key (kbd "C-=") 'er/expand-region)

;; Some proper jumping
(use-package jump-char
  :defer t
  :bind
  (("C-c f" . jump-char-forward)
   ("C-c b" . jump-char-backward)))

;; Usefull functions that can act on a region.
(use-package selected
  :ensure t
  :commands selected-minor-mode
  :bind (:map selected-keymap
              ("q" . selected-off)
              ("u" . upcase-region)
              ("d" . downcase-region)
              ("w" . count-words-region)
              ("m" . apply-macro-to-region-lines)))

;; Splelling is hard. Let's get some hlep.
(use-package ispell
  :defer t
  :init
  (setenv "LANG" "en_US.UTF-8")
  (setq ispell-program-name "hunspell"
	ispell-dictionary "en_US"
	ispell-dictionary-alist
	'((nil "[A-Za-z]" "[^A-Za-z]" "[']" t ("-d" "en_US") nil utf-8))))

;; And closing brackets (or parentheses is also difficult...
(electric-pair-mode t)

;; Remove white space at the end of lines before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Unfill mode
(use-package unfill
  :defer t)

;; LaTeX rules!
(use-package tex
  :defer t
  :ensure auctex)

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
(use-package tempel
  :bind (("M-[" . tempel-complete) ;; Alternative tempel-expand
         ("M-]" . tempel-insert)))

;; Find tempo template file
(defun wg/find-templates ()
  "Edit tempel templates."
  (interactive)
  (find-file "~/.emacs.d/templates"))
(global-set-key (kbd "C-c t") 'wg/find-templates)


;;
;; Org mode
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Let's get organized... Though mostly used for writing
(use-package org
  :hook (org-mode . wg/org-mode-setup)
  :mode("\\.org" . org-mode)
  :defer t
  :config
  (setq org-image-actual-width nil ;; images inline
	org-hide-emphasis-markers t
	org-fontify-whole-heading-line t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (latex . t)))

  ;; Font setup
  (wg/org-font-setup)

  ;; Org-ref
  (use-package org-ref
    :config
    (progn
    (setq reftex-default-bibliography
	    `(,(concat literature-dir "references.bib")
	      ,(concat work-dir "publications\\publications.bib")))
    (setq org-ref-bibliography-notes
	    (concat literature-dir "notes"))
    (setq org-ref-default-bibliography
	    `(,(concat literature-dir "references.bib")
	      ,(concat work-dir "publications\\publications.bib")))))

  ;; Org export
  (require 'ox-latex)
  (add-to-list 'org-latex-classes
	       '("report_wg"
		 "\\documentclass{scrartcl}"
		 ("\\section{%s}" . "\\section*{%s}")
		 ("\\subsection{%s}" . "\\subsection*{%s}")
		 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		 ("\\paragraph{%s}" . "\\paragraph*{%s}")
		 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (require 'ox-beamer)
  (add-to-list 'org-beamer-environments-extra
	       '("onlyenv" "O" "\\begin{onlyenv}%a" "\\end{onlyenv}"))

  (setq temporary-file-directory "c:/wjbg/.temp/")
  (setq org-preview-latex-default-process 'dvipng))

(use-package visual-fill-column
  :hook (org-mode . wg/org-mode-visual-fill))

;; Pretty bullets, I like shiny things...
(use-package org-superstar
  :ensure
  :after org
  :config
  (setq org-superstar-remove-leading-stars t
	org-superstar-headline-bullets-list '(" ")
	org-superstar-item-bullet-alist '((?+ . ?•)
					  (?* . ?➤)
					  (?- . ?–)))
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

;; Set-up PDF tools
(pdf-tools-install)

;; Org-roam - let's try this baby
(use-package org-roam
  :ensure t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory (concat work-dir "notes/"))
  :bind ( (("C-c n l" . org-roam-buffer-toggle)
           ("C-c n f" . org-roam-node-find)
           ("C-c n g" . org-roam-graph))
          :map org-mode-map
          (("C-c n i" . org-roam-node-insert))
          (("C-c n I" . org-roam-insert-immediate))))


;;
;; Elfeed, Reference Management and Projectile
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Stay informed
(use-package elfeed
  :defer t
  :bind ("C-c e" . elfeed)
  :config
  (setq elfeed-feeds
	'(("http://rss.sciencedirect.com/publication/science/1359835X" Comp.A)
	  ("http://rss.sciencedirect.com/publication/science/02663538" Comp.Sci.Tech.)
	  ("http://rss.sciencedirect.com/publication/science/13598368" Comp.B)
	  ("https://rss.sciencedirect.com/publication/science/02638223" JCS)
          ("https://journals.sagepub.com/action/showFeed?ui=0&mi=ehikzz&ai=2b4&jc=jtca&type=etoc&feed=rss" JTCM)
	  ("https://journals.sagepub.com/action/showFeed?ui=0&mi=ehikzz&ai=2b4&jc=jcma&type=etoc&feed=rss" JCM)
	  ("https://www.tandfonline.com/feed/rss/tacm20" Adv.CM)
	  ("https://data.4tu.nl/rss/portal_category/4tu/13630" 4TU.RD))
	elfeed-search-title-max-width 120)
  (add-hook 'elfeed-show-mode-hook 'toggle-truncate-lines))

(use-package ivy-bibtex
  :defer t
  :config
  (setq bibtex-completion-bibliography
           	  `(,(concat literature-dir "references.bib")
		    ,(concat work-dir "publications\\publications.bib"))
	reftex-completion-bibliography
	          `(,(concat literature-dir "references.bib")
		    ,(concat work-dir "publications\\publications.bib"))
        bibtex-completion-library-path `(,literature-dir
					 ,(concat work-dir "publications"))
        bibtex-completion-pdf-field "file"
	bibtex-completion-notes-path (concat literature-dir "notes")
	org-ref-completion-library 'org-ref-ivy-cite
	bibtex-completion-pdf-open-function (lambda (fpath)
					      (start-process "open-pdf" "*open-pdf*"
							     (concat program-files "SumatraPDF\\SumatraPDF.exe") fpath))))


;;
;; Python
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; Virtual environments
(use-package pyvenv
  :ensure t
  :config
  (setq pyvenv-mode-line-indicator
        '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
  (pyvenv-mode 1)
  (pyvenv-activate "~\\.venvs\\base"))

(use-package eglot
  :ensure t
  :defer t
  :hook (python-mode . eglot-ensure))

;; And make use of a proper interpreter...
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")

;; (setenv "LANG" "en_US.UTF-8")
(setenv "PYTHONIOENCODING" "utf-8")

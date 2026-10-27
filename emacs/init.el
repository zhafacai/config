;;; -*- lexical-binding: t -*-
(set-default-toplevel-value 'lexical-binding t)

;; setup package.el
(setq package-archives '(("gnu"    . "https://mirrors.cernet.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.cernet.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.cernet.edu.cn/elpa/melpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'custom-theme-load-path (expand-file-name "lisp" user-emacs-directory))

(require 'zfc-loader)

(require 'zfc-edit)
(require 'zfc-ui)
(require 'zfc-base)
(require 'zfc-dev)
(require 'zfc-org)
(require 'zfc-tool)
(require 'zfc-lang)

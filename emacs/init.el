;;; -*- lexical-binding: t -*-
(set-default-toplevel-value 'lexical-binding t)

;; setup package.el
(setq package-archives '(("gnu"    . "https://mirrors.cernet.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.cernet.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.cernet.edu.cn/elpa/melpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Add the folder to the search path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(setq use-package-always-ensure t)

(require 'zfc-edit)
(require 'zfc-ui)
(require 'zfc-base)
(require 'zfc-dev)
(require 'zfc-org)
(require 'zfc-tool)
(require 'zfc-lang)

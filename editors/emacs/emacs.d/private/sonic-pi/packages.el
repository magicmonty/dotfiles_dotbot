;;; packages.el --- sonic-pi Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq sonic-pi-packages
    '(
      ;; package names go here
      sonic-pi
      dash
      osc
      highlight
      ))

;; List of packages to exclude.
(setq sonic-pi-excluded-packages '())

(defun sonic-pi/init-sonic-pi ()
  "Initialize the Sonic PI package"
  (use-package sonic-pi
    :defer t
    :init
      (add-hook 'sonic-pi-mode-hook
                (lambda ()
                  (setq sonic-pi-path sonic-pi-application-directory)
                  (spacemacs/declare-prefix "m" "sonic-pi")
                  (spacemacs/declare-prefix "me" "evaluate")
                  (spacemacs/declare-prefix "mr" "recording")
                  (spacemacs/declare-prefix "ms" "server")
                  (spacemacs/set-leader-keys-for-minor-mode 'sonic-pi-mode
                    "meb" 'sonic-pi-send-buffer
                    "mer" 'sonic-pi-send-region
                    "mes" 'sonic-pi-stop-all
                    "mq" 'sonic-pi-quit
                    "msj" 'sonic-pi-jack-in
                    "msc" 'sonic-pi-connect
                    "msp" 'sonic-pi-ping
                    "msr" 'sonic-pi-restart
                    "mrr" 'sonic-pi-start-recording
                    "mrs" 'sonic-pi-stop-recording
                  )
                )
      )
  )
)

(defun sonic-pi/init-dash ()
  "Initialize dash"
  (use-package dash
    :defer t))

(defun sonic-pi/init-osc ()
  "Initialize OSC"
  (use-package osc
    :defer t))

(defun sonic-pi/init-highlight ()
  "Initialize highlight"
  (use-package highlight
    :defer t))

;; For each package, define a function sonic-pi/init-<package-name>
;;
;; (defun sonic-pi/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

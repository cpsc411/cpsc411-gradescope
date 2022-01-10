#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt"
         cpsc411/compiler-lib
         cpsc411/test-suite/public/a1
         cpsc411/test-suite/private/a1)

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var check-paren-x64 from "compiler.rkt")
(define-var interp-paren-x64 from "compiler.rkt")
(define-var generate-x64 from "compiler.rkt")
(define-var wrap-x64-run-time from "compiler.rkt")
(define-var wrap-x64-boilerplate from "compiler.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html

(generate-results
 (test-suite ""
  (a1-public-test-suite
   (list
    check-paren-x64
    generate-x64
    wrap-x64-run-time
    wrap-x64-boilerplate)
   interp-paren-x64)

  (a1-private-test-suite
   (list
    check-paren-x64
    generate-x64
    wrap-x64-run-time
    wrap-x64-boilerplate)
   interp-paren-x64)))


#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt"
         cpsc411/compiler-lib
         cpsc411/2c-run-time
         ;; NB: workaround typo in v3 public test suite
         (except-in cpsc411/langs/v3 values-lang-v3)
         cpsc411/langs/v2
         cpsc411/langs/v2-reg-alloc
         cpsc411/test-suite/public/v3
         cpsc411/test-suite/public/v2-reg-alloc
         cpsc411/test-suite/private/v3)

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var check-values-lang   from "compiler.rkt")
(define-var uniquify            from "compiler.rkt")
(define-var sequentialize-let   from "compiler.rkt")
(define-var normalize-bind      from "compiler.rkt")
(define-var select-instructions from "compiler.rkt")
(define-var uncover-locals      from "compiler.rkt")
(define-var replace-locations   from "compiler.rkt")
(define-var assign-homes-opt    from "compiler.rkt")
(define-var undead-analysis     from "compiler.rkt")
(define-var conflict-analysis   from "compiler.rkt")
(define-var assign-registers    from "compiler.rkt")
(define-var flatten-begins      from "compiler.rkt")
(define-var implement-fvars     from "compiler.rkt")
(define-var patch-instructions  from "compiler.rkt")
(define-var generate-x64        from "compiler.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html

(define pass-ls
  (list
   check-values-lang
   uniquify
   sequentialize-let
   normalize-bind
   select-instructions
   assign-homes-opt
   flatten-begins
   patch-instructions
   implement-fvars
   generate-x64
   wrap-x64-run-time
   wrap-x64-boilerplate))

(define interp-ls
  (list
   interp-values-lang-v3
   interp-values-lang-v3
   interp-values-unique-lang-v3
   interp-imp-mf-lang-v3
   interp-imp-cmf-lang-v3
   interp-asm-lang-v2
   interp-nested-asm-lang-v2
   interp-para-asm-lang-v2
   interp-paren-x64-fvars-v2
   interp-paren-x64-v2
   #f #f))

(define TOTAL_TESTS 897)

(generate-results
 (test-suite
  ""
  (v2-reg-alloc-public-test-suite undead-analysis conflict-analysis assign-registers)
  (v3-public-test-sutie pass-ls interp-ls)
  (v3-private-test-suite pass-ls interp-ls))
 (lambda (_) TOTAL_TESTS))

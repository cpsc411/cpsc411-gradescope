#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt"
         cpsc411/compiler-lib
         cpsc411/2c-run-time
         cpsc411/langs/v5
         cpsc411/test-suite/public/v5
         cpsc411/test-suite/private/v5)

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var check-values-lang          from "compiler.rkt")
(define-var uniquify                   from "compiler.rkt")
(define-var sequentialize-let          from "compiler.rkt")
(define-var normalize-bind             from "compiler.rkt")
(define-var impose-calling-conventions from "compiler.rkt")
(define-var select-instructions        from "compiler.rkt")
(define-var uncover-locals             from "compiler.rkt")
(define-var undead-analysis            from "compiler.rkt")
(define-var conflict-analysis          from "compiler.rkt")
(define-var assign-registers           from "compiler.rkt")
(define-var replace-locations          from "compiler.rkt")
(define-var assign-homes-opt           from "compiler.rkt")
(define-var optimize-predicates        from "compiler.rkt")
(define-var expose-basic-blocks        from "compiler.rkt")
(define-var resolve-predicates         from "compiler.rkt")
(define-var flatten-program            from "compiler.rkt")
(define-var patch-instructions         from "compiler.rkt")
(define-var implement-fvars            from "compiler.rkt")
(define-var generate-x64               from "compiler.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html
(define pass-map
  (list
   ;(cons check-values-lang interp-values-lang-v5)
   (cons uniquify interp-values-lang-v5)
   (cons sequentialize-let interp-values-unique-lang-v5)
   (cons normalize-bind interp-imp-mf-lang-v5)
   (cons impose-calling-conventions interp-proc-imp-cmf-lang-v5)
   (cons select-instructions interp-imp-cmf-lang-v5)

   (cons uncover-locals interp-asm-pred-lang-v5)
   (cons undead-analysis interp-asm-pred-lang-v5/locals)
   (cons conflict-analysis interp-asm-pred-lang-v5/undead)
   (cons assign-registers interp-asm-pred-lang-v5/conflicts)
   (cons replace-locations interp-asm-pred-lang-v5/assignments)

   (cons optimize-predicates interp-nested-asm-lang-v5)
   (cons expose-basic-blocks interp-nested-asm-lang-v5)
   (cons resolve-predicates interp-block-pred-lang-v5)
   (cons flatten-program interp-block-asm-lang-v5)
   (cons patch-instructions interp-para-asm-lang-v5)
   (cons implement-fvars interp-paren-x64-fvars-v5)
   (cons generate-x64 interp-paren-x64-v5)
   (cons wrap-x64-run-time #f)
   (cons wrap-x64-boilerplate #f)))

  (current-pass-list
   (map car pass-map))

(define AT_LEAST_TOTAL_TESTS 3809)

(generate-results
 (test-suite
  ""
  (v5-public-test-suite
   (current-pass-list)
   (map cdr pass-map)

   check-values-lang)

  (v5-private-test-suite
   (current-pass-list)
   (map cdr pass-map)

   uniquify
   uncover-locals
   undead-analysis
   impose-calling-conventions
   check-values-lang))
 (lambda (x) (max x AT_LEAST_TOTAL_TESTS)))

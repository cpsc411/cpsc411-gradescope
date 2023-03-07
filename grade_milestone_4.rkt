
#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt"
         cpsc411/compiler-lib
         cpsc411/2c-run-time
         cpsc411/langs/v4
         cpsc411/test-suite/public/v4
         cpsc411/test-suite/private/v4)

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var link-paren-x64       from "compiler.rkt")
(define-var interp-paren-x64     from "compiler.rkt")
(define-var interp-values-lang   from "compiler.rkt")
(define-var check-values-lang    from "compiler.rkt")
(define-var uniquify             from "compiler.rkt")
(define-var sequentialize-let    from "compiler.rkt")
(define-var normalize-bind       from "compiler.rkt")
(define-var select-instructions  from "compiler.rkt")
(define-var uncover-locals       from "compiler.rkt")
(define-var undead-analysis      from "compiler.rkt")
(define-var conflict-analysis    from "compiler.rkt")
(define-var assign-registers     from "compiler.rkt")
(define-var replace-locations    from "compiler.rkt")
(define-var assign-homes-opt     from "compiler.rkt")
(define-var optimize-predicates  from "compiler.rkt")
(define-var expose-basic-blocks  from "compiler.rkt")
(define-var resolve-predicates   from "compiler.rkt")
(define-var flatten-program      from "compiler.rkt")
(define-var patch-instructions   from "compiler.rkt")
(define-var implement-fvars      from "compiler.rkt")
(define-var generate-x64         from "compiler.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html
(define pass-map
  (list
   (cons uniquify interp-values-lang-v4)
   (cons sequentialize-let interp-values-unique-lang-v4)
   (cons normalize-bind interp-imp-mf-lang-v4)
   (cons select-instructions interp-imp-cmf-lang-v4)

   (cons uncover-locals interp-asm-pred-lang-v4)
   (cons undead-analysis interp-asm-pred-lang-v4/locals)
   (cons conflict-analysis interp-asm-pred-lang-v4/undead)
   (cons assign-registers interp-asm-pred-lang-v4/conflicts)
   (cons replace-locations interp-asm-pred-lang-v4/assignments)

   (cons optimize-predicates interp-nested-asm-lang-v4)
   (cons expose-basic-blocks interp-nested-asm-lang-v4)
   (cons resolve-predicates interp-block-pred-lang-v4)
   (cons flatten-program interp-block-asm-lang-v4)
   (cons patch-instructions interp-para-asm-lang-v4)
   (cons implement-fvars interp-paren-x64-fvars-v4)
   (cons generate-x64 interp-paren-x64-v4)
   (cons wrap-x64-run-time #f)
   (cons wrap-x64-boilerplate #f)))

  (current-pass-list
   (map car pass-map))

(define TOTAL_TESTS 2077)

(generate-results
 (test-suite
  ""
  (v4-public-test-suite
   (current-pass-list)
   (map cdr pass-map)

   link-paren-x64
   interp-paren-x64
   interp-values-lang
   check-values-lang)

  (v4-private-test-suite
   (current-pass-list)
   (map cdr pass-map)

   link-paren-x64
   interp-paren-x64
   interp-values-lang
   check-values-lang))
 (lambda (_) TOTAL_TESTS))

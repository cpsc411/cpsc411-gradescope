#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt"
         rackunit/text-ui
         cpsc411/compiler-lib
         cpsc411/ptr-run-time
         cpsc411/langs/v7
         cpsc411/test-suite/public/v7
         cpsc411/test-suite/private/v7)

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var uniquify                     from "compiler.rkt")
(define-var implement-safe-primops       from "compiler.rkt")
(define-var specify-representation       from "compiler.rkt")
(define-var remove-complex-opera*        from "compiler.rkt")
(define-var sequentialize-let            from "compiler.rkt")
(define-var normalize-bind               from "compiler.rkt")
(define-var impose-calling-conventions   from "compiler.rkt")
(define-var select-instructions          from "compiler.rkt")
(define-var uncover-locals               from "compiler.rkt")
(define-var undead-analysis              from "compiler.rkt")
(define-var conflict-analysis            from "compiler.rkt")
(define-var assign-call-undead-variables from "compiler.rkt")
(define-var allocate-frames              from "compiler.rkt")
(define-var assign-registers             from "compiler.rkt")
(define-var replace-locations            from "compiler.rkt")
(define-var assign-frame-variables       from "compiler.rkt")
(define-var implement-fvars              from "compiler.rkt")
(define-var optimize-predicates          from "compiler.rkt")
(define-var expose-basic-blocks          from "compiler.rkt")
(define-var resolve-predicates           from "compiler.rkt")
(define-var flatten-program              from "compiler.rkt")
(define-var patch-instructions           from "compiler.rkt")
(define-var generate-x64                 from "compiler.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html
(define pass-map
    (list
     #;(cons check-exprs-lang #f)
     (cons uniquify interp-exprs-lang-v7)
     (cons implement-safe-primops interp-exprs-unique-lang-v7)
     (cons specify-representation interp-exprs-unsafe-data-lang-v7)
     (cons remove-complex-opera* interp-exprs-bits-lang-v7)
     (cons sequentialize-let interp-values-bits-lang-v7)
     (cons normalize-bind interp-imp-mf-lang-v7)
     (cons impose-calling-conventions interp-proc-imp-cmf-lang-v7)
     (cons select-instructions interp-imp-cmf-lang-v7)
     (cons uncover-locals interp-asm-pred-lang-v7)
     (cons undead-analysis interp-asm-pred-lang-v7/locals)
     (cons conflict-analysis interp-asm-pred-lang-v7/undead)
     (cons assign-call-undead-variables interp-asm-pred-lang-v7/conflicts)
     (cons allocate-frames interp-asm-pred-lang-v7/pre-framed)
     (cons assign-registers interp-asm-pred-lang-v7/framed)
     (cons assign-frame-variables interp-asm-pred-lang-v7/spilled)
     (cons replace-locations interp-asm-pred-lang-v7/assignments)
     (cons optimize-predicates interp-nested-asm-lang-fvars-v7)
     (cons implement-fvars interp-nested-asm-lang-fvars-v7)
     (cons expose-basic-blocks interp-nested-asm-lang-v7)
     (cons resolve-predicates interp-block-pred-lang-v7)
     (cons flatten-program interp-block-asm-lang-v7)
     (cons patch-instructions interp-para-asm-lang-v7)
     (cons generate-x64 interp-paren-x64-v7)
     (cons wrap-x64-boilerplate #f)
     (cons wrap-x64-run-time #f)))

(current-pass-list
 (map car pass-map))

(define AT_LEAST_TOTAL_TESTS 1442)

(provide test-suite-hash AT_LEAST_TOTAL_TESTS)
(define test-suite-hash
  (generate-results/hash
   (test-suite
    ""
    (v7-public-test-suite
     (map car pass-map)
     (map cdr pass-map))

    (v7-private-test-suite
     (current-pass-list)
     (map cdr pass-map)))
   (lambda (x) (max x AT_LEAST_TOTAL_TESTS))))

(module+ main
  (produce-report/exit
   test-suite-hash))

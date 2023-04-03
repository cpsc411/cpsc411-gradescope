#lang racket

(require rackunit) ;; WARNING: Use the test- forms, NOT the check- forms!

(require "lib-grade.rkt"
         rackunit/text-ui
         cpsc411/compiler-lib
         cpsc411/ptr-run-time
         cpsc411/langs/v8
         cpsc411/langs/v9
         cpsc411/test-suite/private/v9
         cpsc411/test-suite/public/v9)

;; Use as many
;;   (define-var <varname> from <filename>)
;; as needed to obtain the variables you want to test.
;; <filename> should be whatever name you asked them to use
;; in their submission. Each <varname> should be a name
;; that you expected them to provide in their assignment.

;; Yes, from is a keyword, it should be there, literally.

(define-var uniquify                     from "compiler.rkt")
(define-var implement-safe-primops       from "compiler.rkt")
(define-var implement-safe-call          from "compiler.rkt")
(define-var define->letrec               from "compiler.rkt")
(define-var optimize-direct-calls        from "compiler.rkt")
(define-var dox-lambdas                  from "compiler.rkt")
(define-var uncover-free                 from "compiler.rkt")
(define-var convert-closures             from "compiler.rkt")
(define-var optimize-known-calls         from "compiler.rkt")
(define-var hoist-lambdas                from "compiler.rkt")
(define-var implement-closures           from "compiler.rkt")
(define-var specify-representation       from "compiler.rkt")
(define-var remove-complex-opera*        from "compiler.rkt")
(define-var sequentialize-let            from "compiler.rkt")
(define-var normalize-bind               from "compiler.rkt")
(define-var impose-calling-conventions   from "compiler.rkt")
(define-var select-instructions          from "compiler.rkt")
(define-var expose-allocation-pointer    from "compiler.rkt")
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
(define-var implement-mops               from "compiler.rkt")
(define-var generate-x64                 from "compiler.rkt")

;; Now define your tests.
;; The suite name can be anything you want.
;; For the individual tests, use the test-* forms in
;; https://docs.racket-lang.org/rackunit/api.html
(define pass-map
    (list
     #;(cons check-exprs-lang #f)
     (cons uniquify interp-exprs-lang-v9)
     (cons implement-safe-primops interp-exprs-unique-lang-v9)
     (cons implement-safe-call interp-exprs-unsafe-data-lang-v9)
     (cons define->letrec interp-exprs-unsafe-lang-v9)
     (cons optimize-direct-calls interp-just-exprs-lang-v9)
     (cons dox-lambdas interp-just-exprs-lang-v9)
     (cons uncover-free interp-lam-opticon-lang-v9)
     (cons convert-closures interp-lam-free-lang-v9)
     (cons optimize-known-calls interp-closure-lang-v9)
     (cons hoist-lambdas interp-closure-lang-v9)
     (cons implement-closures interp-hoisted-lang-v9)
     (cons specify-representation interp-proc-exposed-lang-v9)
     (cons remove-complex-opera* interp-exprs-bits-lang-v8)
     (cons sequentialize-let interp-values-bits-lang-v8)
     (cons normalize-bind interp-imp-mf-lang-v8)
     (cons impose-calling-conventions interp-proc-imp-cmf-lang-v8)
     (cons select-instructions interp-imp-cmf-lang-v8)
     (cons expose-allocation-pointer interp-asm-alloc-lang-v8)
     (cons uncover-locals interp-asm-pred-lang-v8)
     (cons undead-analysis interp-asm-pred-lang-v8/locals)
     (cons conflict-analysis interp-asm-pred-lang-v8/undead)
     (cons assign-call-undead-variables interp-asm-pred-lang-v8/conflicts)
     (cons allocate-frames interp-asm-pred-lang-v8/pre-framed)
     (cons assign-registers interp-asm-pred-lang-v8/framed)
     (cons assign-frame-variables interp-asm-pred-lang-v8/spilled)
     (cons replace-locations interp-asm-pred-lang-v8/assignments)
     (cons optimize-predicates interp-nested-asm-lang-fvars-v8)
     (cons implement-fvars interp-nested-asm-lang-fvars-v8)
     (cons expose-basic-blocks interp-nested-asm-lang-v8)
     (cons resolve-predicates interp-block-pred-lang-v8)
     (cons flatten-program interp-block-asm-lang-v8)
     (cons patch-instructions interp-para-asm-lang-v8)
     (cons implement-mops interp-paren-x64-mops-v8)
     (cons generate-x64 interp-paren-x64-v8)
     (cons wrap-x64-boilerplate #f)
     (cons wrap-x64-run-time #f)))

(current-pass-list
 (map car pass-map))

(provide test-suite-hash AT_LEAST_TOTAL_TESTS)
(define AT_LEAST_TOTAL_TESTS 3846)

(define test-suite-hash
  (generate-results/hash
   (test-suite
    ""
    (v9-public-test-suite
     (map car pass-map)
     (map cdr pass-map))

    (v9-private-test-suite
     (current-pass-list)
     (map cdr pass-map)))
   (lambda (x) (max x AT_LEAST_TOTAL_TESTS))))

(module+ main
  (produce-report/exit
   test-suite-hash))

#lang racket

(require
 cpsc411/compiler-lib
 cpsc411/ptr-run-time)

(provide
 uniquify
 implement-safe-primops
 implement-safe-call
 define->letrec
 optimize-direct-calls
 dox-lambdas
 uncover-free
 convert-closures
 optimize-known-calls
 hoist-lambdas
 implement-closures
 specify-representation
 remove-complex-opera*
 sequentialize-let
 normalize-bind
 impose-calling-conventions
 select-instructions
 expose-allocation-pointer
 uncover-locals
 undead-analysis
 conflict-analysis
 assign-call-undead-variables
 allocate-frames
 assign-registers
 assign-frame-variables
 replace-locations
 implement-fvars
 optimize-predicates
 expose-basic-blocks
 resolve-predicates
 flatten-program
 patch-instructions
 implement-mops
 generate-x64)

;; TODO: Fill in.
;; You'll want to merge milestone-8 code in

;; Stubs; remove or replace with your definitions.
(define-values (uniquify
                implement-safe-primops
                implement-safe-call
                define->letrec
                optimize-direct-calls
                dox-lambdas
                uncover-free
                convert-closures
                optimize-known-calls
                hoist-lambdas
                implement-closures
                specify-representation
                remove-complex-opera*
                sequentialize-let
                normalize-bind
                impose-calling-conventions
                select-instructions
                expose-allocation-pointer
                uncover-locals
                undead-analysis
                conflict-analysis
                assign-call-undead-variables
                allocate-frames
                assign-registers
                assign-frame-variables
                replace-locations
                implement-fvars
                optimize-predicates
                expose-basic-blocks
                resolve-predicates
                flatten-program
                patch-instructions
                implement-mops
                generate-x64)
  (values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values
   values))

(module+ test
  (require
   rackunit
   rackunit/text-ui
   cpsc411/langs/v8
   cpsc411/langs/v9
   cpsc411/test-suite/public/v9)

  ;; You can modify this pass list, e.g., by adding other
  ;; optimization, debugging, or validation passes.
  ;; Doing this may provide additional debugging info when running the rest
  ;; suite.
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

  (run-tests
   (v9-public-test-suite
    (current-pass-list)
    (map cdr pass-map))))

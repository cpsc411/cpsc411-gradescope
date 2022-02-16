#lang racket

(require
 cpsc411/compiler-lib
 cpsc411/2c-run-time)

(provide
 check-values-lang
 uniquify
 sequentialize-let
 normalize-bind
 impose-calling-conventions
 select-instructions
 assign-homes-opt
 uncover-locals
 undead-analysis
 conflict-analysis
 assign-registers
 replace-locations
 optimize-predicates
 expose-basic-blocks
 resolve-predicates
 flatten-program
 patch-instructions
 implement-fvars
 generate-x64)

;; TODO: Fill in.
;; You'll want to merge milestone-4 code in

;; Stubs; remove or replace with your definitions.
(define-values (check-values-lang
                uniquify
                sequentialize-let
                normalize-bind
                impose-calling-conventions
                select-instructions
                assign-homes-opt
                uncover-locals
                undead-analysis
                conflict-analysis
                assign-registers
                replace-locations
                optimize-predicates
                expose-basic-blocks
                resolve-predicates
                flatten-program
                patch-instructions
                implement-fvars
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
   values))

(module+ test
  (require
   rackunit
   rackunit/text-ui
   cpsc411/langs/v5
   cpsc411/test-suite/utils
   cpsc411/test-suite/public/v5
   errortrace)

  ;; You can modify this pass list, e.g., by adding check-assignment, or other
  ;; debugging and validation passes.
  ;; Doing this may provide additional debugging info when running the rest
  ;; suite.
  (define pass-map
    (list
     (cons check-values-lang interp-values-lang-v5)
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

  (run-tests
   (v5-public-test-suite
    (current-pass-list)
    (map cdr pass-map)

    check-values-lang)))

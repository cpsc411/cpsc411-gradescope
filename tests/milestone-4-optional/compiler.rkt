#lang racket

(require
 (except-in cpsc411/reference/a4-solution
            link-paren-x64
            interp-paren-x64
            interp-values-lang
            check-values-lang))

(define-values (link-paren-x64
                interp-paren-x64
                interp-values-lang
                check-values-lang)
  (values #f #f #f #f))

(provide
 link-paren-x64
 interp-paren-x64
 interp-values-lang
 check-values-lang

 uniquify
 sequentialize-let
 normalize-bind
 select-instructions
 uncover-locals
 undead-analysis
 conflict-analysis
 assign-registers
 replace-locations
 assign-homes-opt
 optimize-predicates
 expose-basic-blocks
 resolve-predicates
 flatten-program
 patch-instructions
 implement-fvars
 generate-x64)

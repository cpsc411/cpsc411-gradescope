#lang racket

(require cpsc411/reference/a5-solution)

(provide
 check-values-lang

 uniquify
 sequentialize-let
 normalize-bind
 impose-calling-conventions
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
